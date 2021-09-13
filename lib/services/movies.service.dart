import 'package:streamerapp/constants/endpoints.constant.dart';
import 'package:streamerapp/models/movie.model.dart';
import 'package:streamerapp/services/base.service.dart';

class MoviesService {
  Future<List<Movie>> getMovies({
    int page = 1,
    String queryTerm = '',
    String sortBy = 'date_added',
    String orderBy = 'desc',
  }) async {
    final String url =
        '${MoviesEndpointsConstant.listUrl}?page=$page&query_term=$queryTerm&sort_by=$sortBy&order_by=$orderBy';
    List<dynamic> movies = await BaseService.list(url);
    return movies.map((e) => Movie.fromJson(e)).toList();
  }

  Future<Movie> getMovie({required int id}) async {
    final String url = '${MoviesEndpointsConstant.detailUrl}?movie_id=$id';
    dynamic movie = await BaseService.get(url);
    return Movie.fromJson(movie);
  }
}
