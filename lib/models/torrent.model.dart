import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamerapp/common/bencode.common.dart' as bencode;

part 'torrent.model.g.dart';

@JsonSerializable()
class Torrent {
  final Info info;
  @JsonKey(fromJson: decodeToString)
  final String announce;
  @JsonKey(name: 'announce-list', fromJson: decodeListToString)
  final List<String>? announceList;
  @JsonKey(name: 'creation date')
  final int? creationDate;
  @JsonKey(fromJson: decodeToStringOrNull)
  final String? comment;
  @JsonKey(name: 'created by', fromJson: decodeToStringOrNull)
  final String? createdBy;
  @JsonKey(fromJson: decodeToStringOrNull)
  final String? encoding;

  Torrent({
    required this.info,
    required this.announce,
    this.announceList,
    this.creationDate,
    this.comment,
    this.createdBy,
    this.encoding,
  });

  factory Torrent.fromJson(Map<String, dynamic> json) =>
      _$TorrentFromJson(json);
  Map<String, dynamic> toJson() => _$TorrentToJson(this);

  Digest get infoHash => sha1.convert(bencode.encode(info.toJson()));
}

@JsonSerializable()
class Info {
  @JsonKey(name: 'piece length')
  final int pieceLength;
  @JsonKey(fromJson: toUint8List)
  final Uint8List pieces;
  final bool? private;

  Info({
    required this.pieceLength,
    required this.pieces,
    this.private,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

String decodeToString(dynamic v) {
  return utf8.decode(v);
}

List<String> decodeListToString(List<dynamic> v) {
  List<String> l = v
      .map((l) => l.map((s) => decodeToString(s)).toString())
      .cast<String>()
      .toList();
  return l;
}

Uint8List toUint8List(dynamic v) {
  return Uint8List.fromList(v);
}

String? decodeToStringOrNull(dynamic v) {
  if (v != null) return utf8.decode(v);
  return null;
}

class ConnectionResponse {
  final int action;
  final int transactionId;
  final Uint8List connectionId;

  ConnectionResponse({
    required this.action,
    required this.transactionId,
    required this.connectionId,
  });
}

class AnnounceResponse {
  final int action;
  final int transactionId;
  final int interval;
  final int leechers;
  final int seeders;
  final List<Peer> peers;

  AnnounceResponse({
    required this.action,
    required this.transactionId,
    required this.interval,
    required this.leechers,
    required this.seeders,
    required this.peers,
  });

  factory AnnounceResponse.fromBuffer(Uint8List data) {
    ByteData bdata = ByteData.view(data.buffer);
    return AnnounceResponse(
      action: bdata.getUint32(0),
      transactionId: bdata.getUint32(4),
      interval: bdata.getUint32(8),
      leechers: bdata.getUint32(12),
      seeders: bdata.getUint32(16),
      peers: group(data.sublist(20), 6)
          .map((g) => Peer(
              ip: g.sublist(0, 4).join('.'),
              port: ByteData.view(g.buffer).getUint16(4)))
          .toList(),
    );
  }

  static List<Uint8List> group(Uint8List iterable, int groupSize) {
    List<Uint8List> groups = [];
    final int gCount = (iterable.length / groupSize).floor();

    List.generate(
        gCount,
        (i) => groups
            .add(iterable.sublist(i * groupSize, (i * groupSize) + groupSize)));
    return groups;
  }
}

class Peer {
  final String ip;
  final int port;

  Peer({
    required this.ip,
    required this.port,
  });
}

enum ResType { connection, announce }
