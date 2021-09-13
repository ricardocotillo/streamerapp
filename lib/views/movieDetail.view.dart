import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:streamerapp/models/movie.model.dart';
import 'package:streamerapp/providers/movie.provider.dart';

class MovieDetailView extends StatefulWidget {
  @override
  State<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  @override
  void dispose() {
    Provider.of<MovieProvider>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MovieProvider movieProvider = Provider.of<MovieProvider>(context);
    final Size size = MediaQuery.of(context).size;
    const TextStyle _titleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
    const TextStyle _subtitleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    const TextStyle _chipStyle = const TextStyle(
      fontSize: 12,
    );
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          Container(
            width: size.width,
            height: size.height * 0.55,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                repeat: ImageRepeat.noRepeat,
                image: CachedNetworkImageProvider(
                    movieProvider.movie.mediumCoverImage ?? ''),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: size.height * 0.5,
              width: size.width,
              color: Color(0xFF181B28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieProvider.movie.titleLong ?? '',
                    style: _titleStyle,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieProvider.movie.genres?.length ?? 0,
                      itemBuilder: (context, i) => Container(
                        decoration: BoxDecoration(
                          border: i < movieProvider.movie.genres!.length - 1
                              ? Border(
                                  right: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                )
                              : null,
                        ),
                        padding: i == 0
                            ? const EdgeInsets.only(right: 10)
                            : i == (movieProvider.movie.genres!.length - 1)
                                ? const EdgeInsets.only(left: 10)
                                : const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          movieProvider.movie.genres?[i],
                          style: _chipStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Synopsis',
                    style: _subtitleStyle,
                  ),
                  SizedBox(height: 10),
                  Text(movieProvider.movie.synopsis ?? '')
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.5,
            child: Container(
              height: size.height * 0.15,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  colors: [
                    Color(0xFF181B28),
                    Color(0xFF181B28).withOpacity(0.0),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: Icon(CupertinoIcons.back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 5,
            child: IconButton(
              icon: Icon(CupertinoIcons.cloud_download),
              onPressed: () => _getMagnets(context,
                  movieProvider.movie.torrents, movieProvider.getTorrent),
            ),
          )
        ],
      ),
    );
  }

  void _getMagnets(BuildContext context, List<TorrentInfo>? torrents,
      void Function(TorrentInfo) onGetTorrent) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('Opciones'),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: torrents
                      ?.map(
                        (e) => GestureDetector(
                          onTap: () => onGetTorrent(e),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: .5,
                              ),
                            ),
                            padding: const EdgeInsets.all(3.0),
                            child: Text(e.quality),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          )
        ],
      ),
    );
  }
}
