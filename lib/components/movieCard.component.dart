import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:streamerapp/models/movie.model.dart';
import 'package:streamerapp/providers/movie.provider.dart';
import 'package:streamerapp/views/movieDetail.view.dart';

class MovieCardComponent extends StatelessWidget {
  final Movie movie;

  const MovieCardComponent({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Provider(
          create: (_) => MovieProvider(movie: movie),
          child: MovieDetailView(),
        ),
      )),
      child: Card(
        color: Color(0xFF181B28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (movie.mediumCoverImage != null)
              Container(
                margin: const EdgeInsets.all(12.0),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: CachedNetworkImage(
                  imageUrl: movie.mediumCoverImage ?? '',
                  width: 100,
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          Container(
                    width: 100,
                    height: 150,
                    color: Colors.white.withOpacity(.1),
                    child: Icon(Icons.image),
                  ),
                  placeholder: (BuildContext context, String url) => Container(
                    width: 100,
                    height: 150,
                    color: Colors.white.withOpacity(.1),
                    child: Icon(Icons.image),
                  ),
                ),
              ),
            Container(
              width: _size.width * 0.66,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        movie.rating?.toStringAsFixed(1) ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Año: ' + (movie.year?.toString() ?? ''),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: _size.width * 0.66,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: movie.genres
                                ?.map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        e,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ))
                                .toList() ??
                            [],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
