class HomeScreenState {
  const HomeScreenState(this._searchQuery, this._page);

  HomeScreenState.fromState(HomeScreenState state,
      {String? searchQuery, int? page})
      : _searchQuery = searchQuery ?? state.searchQuery,
        _page = page ?? state.page;

  final String? _searchQuery;
  final int _page;

  String? get searchQuery => _searchQuery;

  int get page => _page;
}
