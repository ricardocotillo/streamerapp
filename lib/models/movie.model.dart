import 'package:json_annotation/json_annotation.dart';

part 'movie.model.g.dart';

@JsonSerializable()
class Movie {
  int id;
  String? url;
  @JsonKey(name: 'imdb_code')
  String? imdbCode;
  String? title;
  @JsonKey(name: 'title_english')
  String? titleEnglish;
  @JsonKey(name: 'title_long')
  String? titleLong;
  String? slug;
  int? year;
  double? rating;
  int? runtime;
  List<dynamic>? genres;
  String? summary;
  @JsonKey(name: 'description_full')
  String? descriptionFull;
  String? synopsis;
  @JsonKey(name: 'yt_trailer_code')
  String? ytTrailerCode;
  String? language;
  @JsonKey(name: 'mpa_rating')
  String? mpaRating;
  @JsonKey(name: 'background_image')
  String? backgroundImage;
  @JsonKey(name: 'background_image_original')
  String? backgroundImageOriginal;
  @JsonKey(name: 'small_cover_image')
  String? smallCoverImage;
  @JsonKey(name: 'medium_cover_image')
  String? mediumCoverImage;
  @JsonKey(name: 'larger_cover_image')
  String? largeCoverImage;
  String? state;
  List<TorrentInfo>? torrents;
  @JsonKey(name: 'date_uploaded')
  String? dateUploaded;
  @JsonKey(name: 'date_uploaded_unix')
  int? dateUploadedUnix;

  Movie({
    required this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.state,
    this.torrents,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class TorrentInfo {
  String url;
  String hash;
  String quality;
  String type;
  int seeds;
  int peers;
  String size;
  @JsonKey(name: 'size_bytes')
  int sizeBytes;
  @JsonKey(name: 'date_uploaded')
  String dateUploaded;
  @JsonKey(name: 'date_uploaded_unix')
  int dateUploadedUnix;

  TorrentInfo({
    required this.url,
    required this.hash,
    required this.quality,
    required this.type,
    required this.seeds,
    required this.peers,
    required this.size,
    required this.sizeBytes,
    required this.dateUploaded,
    required this.dateUploadedUnix,
  });

  factory TorrentInfo.fromJson(Map<String, dynamic> json) =>
      _$TorrentInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TorrentInfoToJson(this);
}
