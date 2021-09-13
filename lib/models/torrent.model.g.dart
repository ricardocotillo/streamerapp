// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torrent.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Torrent _$TorrentFromJson(Map<String, dynamic> json) => Torrent(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      announce: decodeToString(json['announce']),
      announceList: decodeListToString(json['announce-list'] as List),
      creationDate: json['creation date'] as int?,
      comment: decodeToStringOrNull(json['comment']),
      createdBy: decodeToStringOrNull(json['created by']),
      encoding: decodeToStringOrNull(json['encoding']),
    );

Map<String, dynamic> _$TorrentToJson(Torrent instance) => <String, dynamic>{
      'info': instance.info,
      'announce': instance.announce,
      'announce-list': instance.announceList,
      'creation date': instance.creationDate,
      'comment': instance.comment,
      'created by': instance.createdBy,
      'encoding': instance.encoding,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      pieceLength: json['piece length'] as int,
      pieces: toUint8List(json['pieces']),
      private: json['private'] as bool?,
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'piece length': instance.pieceLength,
      'pieces': instance.pieces,
      'private': instance.private,
    };
