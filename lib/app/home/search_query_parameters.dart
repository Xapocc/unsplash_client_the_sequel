class SearchQueryParams {
  const SearchQueryParams(this._searchQuery, this._page);

  final String _searchQuery;
  final int _page;

  String get searchQuery => _searchQuery;

  int get page => _page;
}
