import 'package:flutter/material.dart';
import 'package:pagination_view/pagination_view.dart';

class SearchPreferencesProvider {
  final GlobalKey<PaginationViewState> listKey =
      GlobalKey<PaginationViewState>();
  String queryTerm = '';
  String _sortBy = 'date_added';
  String _orderBy = 'desc';

  void setQueryTerm(String q) {
    queryTerm = q;
    listKey.currentState?.refresh();
  }

  String get sortBy => queryTerm.isEmpty ? _sortBy : 'title';
  String get orderBy => queryTerm.isEmpty ? _orderBy : 'asc';
}
