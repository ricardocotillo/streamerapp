import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:streamerapp/components/appBar.component.dart';
import 'package:streamerapp/components/movieCard.component.dart';
import 'package:streamerapp/models/movie.model.dart';
import 'package:streamerapp/providers/home.provider.dart';
import 'package:streamerapp/services/movies.service.dart';
import 'package:pagination_view/pagination_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MoviesService _moviesService = MoviesService();

  @override
  Widget build(BuildContext context) {
    final SearchPreferencesProvider searchPreferencesProvider =
        Provider.of<SearchPreferencesProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            PaginationView<Movie>(
              key: searchPreferencesProvider.listKey,
              shrinkWrap: true,
              pageFetch: (int page) async {
                return _moviesService.getMovies(
                  page: page,
                  queryTerm: searchPreferencesProvider.queryTerm,
                  sortBy: searchPreferencesProvider.sortBy,
                  orderBy: searchPreferencesProvider.orderBy,
                );
              },
              itemBuilder: (BuildContext context, Movie movie, int i) => i == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: MovieCardComponent(movie: movie),
                    )
                  : MovieCardComponent(movie: movie),
              onError: (dynamic error) => Center(
                child: Text('Sucedió un error'),
              ),
              onEmpty: Center(
                child: Text('No se encontraron películas'),
              ),
              bottomLoader: Center(
                child: CircularProgressIndicator(),
              ),
              initialLoader: Center(
                child: CircularProgressIndicator(),
              ),
              pullToRefresh: true,
            ),
            AppBarComponent(),
          ],
        ),
      ),
    );
  }
}
