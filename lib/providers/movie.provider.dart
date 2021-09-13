import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:streamerapp/common/functions.common.dart';
import 'package:streamerapp/controllers/magnet.controller.dart';
import 'package:streamerapp/models/movie.model.dart';
import 'package:streamerapp/models/torrent.model.dart';
import 'package:streamerapp/common/bencode.common.dart' as bencode;

class MovieProvider {
  Movie movie;
  Torrent? torrent;

  int tries = 0;
  bool connected = false;

  RawDatagramSocket? _udpSocket;

  StreamSubscription? _socketListen;

  final MagnetController _magnetController = MagnetController();

  List<Peer>? _peers;

  ServerSocket? _serverSocket;

  MovieProvider({
    required this.movie,
    this.torrent,
  });

  void getTorrent(TorrentInfo torrentInfo) async {
    final Torrent torrent = await _magnetController.getTorrent(torrentInfo.url);
    getPeers(torrent, torrentInfo);
  }

  void getPeers(Torrent torrent, TorrentInfo torrentInfo) async {
    String url = torrent.announce;
    final Uri uri = Uri.parse(url);
    final InternetAddress iurl = await parseUrl(uri);
    Uint8List connReq = buildConnReq();
    _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _udpSocket?.writeEventsEnabled = true;
    _socketListen = _udpSocket?.listen((RawSocketEvent event) async {
      final Datagram? dg = _udpSocket?.receive();
      if (event == RawSocketEvent.read) {
        if (dg != null) {
          if (resType(dg.data) == ResType.connection) {
            connected = true;
            final ConnectionResponse connRes = parseConnResp(dg.data);
            final Uint8List announceReq = buildAnnounceReq(
                connRes.connectionId, torrent, torrentInfo.sizeBytes);
            udpSend(_udpSocket!, announceReq, iurl, uri.port);
          } else if (resType(dg.data) == ResType.announce) {
            final AnnounceResponse annRes = parseAnnounceResp(dg.data);
            _peers = annRes.peers;
            _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
            _peers?.forEach((p) {
              download(p);
            });
            close();
          }
        }
      }
    }, onError: (Object err) {
      print(err.toString());
      close();
    });
    connect(_udpSocket!, connReq, iurl, uri.port);
  }

  void download(Peer peer) async {
    Socket socket = await Socket.connect(peer.ip, peer.port);
    StreamSubscription? subscription;
    subscription = socket.listen((Uint8List data) {
      print(data);
      socket.close();
      subscription?.cancel();
    });
    socket.write(buildHandshake());
  }

  Uint8List buildHandshake() {
    ByteData bdata = ByteData(68);
    bdata.setUint8(0, 19);
    List<int> protocol = utf8.encode('BitTorrent protocol');
    List.generate(protocol.length, (i) => bdata.setUint8(1 + i, protocol[i]));
    bdata.setUint32(20, 0);
    bdata.setUint32(24, 0);
    Digest d = torrent!.infoHash;
    List.generate(d.bytes.length, (i) => bdata.setUint8(28 + i, d.bytes[i]));
    Uint8List id = genId();
    List.generate(id.length, (i) => bdata.setUint8(d.bytes.length + i, id[i]));
    return bdata.buffer.asUint8List();
  }

  void connect(RawDatagramSocket socket, Uint8List message,
      InternetAddress address, int port) {
    udpSend(socket, message, address, port);
    tries += 1;
    Timer(Duration(seconds: (15 * pow(2, tries)).toInt()), () {
      if (!connected && tries < 8) {
        connect(socket, message, address, port);
      }
    });
  }

  void udpSend(RawDatagramSocket socket, Uint8List message,
      InternetAddress address, int port) {
    int result = socket.send(message, address, port);
    print('Sent connection request: $result');
  }

  Future<InternetAddress> parseUrl(Uri uri) async {
    List<InternetAddress> addresses = await InternetAddress.lookup(uri.host);
    return addresses.first;
  }

  Uint8List buildConnReq() {
    final ByteData bdata = ByteData(16);
    bdata.setUint64(0, 0x41727101980);
    bdata.setUint32(8, 0);
    List<int> rBytes = randomBytes(4);
    List.generate(rBytes.length, (i) {
      bdata.setUint8(12 + i, rBytes[i]);
    });
    Uint8List buff = bdata.buffer.asUint8List();
    return buff;
  }

  ConnectionResponse parseConnResp(Uint8List resp) {
    ByteData bdata = ByteData.view(resp.buffer);
    int action = bdata.getUint32(0);
    int transactionId = bdata.getUint32(4);
    Uint8List connectionId = resp.sublist(8);

    return ConnectionResponse(
      action: action,
      transactionId: transactionId,
      connectionId: connectionId,
    );
  }

  Uint8List buildAnnounceReq(Uint8List connectionId, Torrent torrent, int size,
      [int port = 6681]) {
    final ByteData bdata = ByteData(98);
    List.generate(
        connectionId.length, (i) => bdata.setInt8(i, connectionId[i]));
    bdata.setUint32(8, 1);
    List<int> rBytes = randomBytes(4);
    List.generate(rBytes.length, (i) => bdata.setUint8(12 + i, rBytes[i]));
    Digest d = torrent.infoHash;
    List.generate(d.bytes.length, (i) => bdata.setUint8(16 + i, d.bytes[i]));
    final Uint8List id = genId();
    List.generate(id.length, (i) => bdata.setUint8(36 + i, id[i]));
    final Uint8List download = Uint8List(8);
    List.generate(download.length, (i) => bdata.setUint8(56 + i, download[i]));
    bdata.setUint64(64, size);
    final Uint8List uploaded = Uint8List(8);
    List.generate(uploaded.length, (i) => bdata.setUint8(72 + i, uploaded[i]));
    bdata.setUint32(80, 0);
    bdata.setUint32(80, 0);
    rBytes = randomBytes(4);
    List.generate(rBytes.length, (i) => bdata.setUint8(88 + i, rBytes[i]));
    bdata.setUint32(92, -1);
    bdata.setUint16(96, port);
    return bdata.buffer.asUint8List();
  }

  AnnounceResponse parseAnnounceResp(Uint8List res) {
    return AnnounceResponse.fromBuffer(res);
  }

  ResType? resType(Uint8List res) {
    final ByteData bdata = ByteData.view(res.buffer);
    final int action = bdata.getUint32(0);
    if (action == 0) return ResType.connection;
    if (action == 1) return ResType.announce;
  }

  void close() {
    _udpSocket?.close();
    _socketListen?.cancel();
  }
}
