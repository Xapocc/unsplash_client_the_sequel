import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';

class HomeScreenState {
  const HomeScreenState(
      {String? searchQuery,
      int page = 1,
      bool isLoadingCompleted = false,
      bool showSearchField = false,
      bool hideAppBar = false,
      bool searchForUser = false,
      List<ImageInfoEntity> imagesInfoEntitiesList = const []})
      : _searchQuery = searchQuery,
        _page = page,
        _isLoadingCompleted = isLoadingCompleted,
        _showSearchField = showSearchField,
        _hideAppBar = hideAppBar,
        _searchForUser = searchForUser,
        _imagesInfoEntitiesList = imagesInfoEntitiesList;

  HomeScreenState.fromState(HomeScreenState state,
      {String? searchQuery,
      int? page,
      bool? isLoadingCompleted,
      bool? showSearchField,
      bool? hideAppBar,
      bool? searchForUser,
      List<ImageInfoEntity>? imagesInfoEntitiesList})
      : _searchQuery = searchQuery ?? state.searchQuery,
        _page = page ?? state.page,
        _isLoadingCompleted = isLoadingCompleted ?? state.isLoadingCompleted,
        _showSearchField = showSearchField ?? state.showSearchField,
        _hideAppBar = hideAppBar ?? state.hideAppBar,
        _searchForUser = searchForUser ?? state.searchForUser,
        _imagesInfoEntitiesList =
            imagesInfoEntitiesList ?? state.imagesInfoEntitiesList;

  final String? _searchQuery;
  final int _page;
  final bool _isLoadingCompleted;
  final bool _showSearchField;
  final bool _hideAppBar;
  final bool _searchForUser;
  final List<ImageInfoEntity> _imagesInfoEntitiesList;

  String? get searchQuery => _searchQuery;

  int get page => _page;

  bool get isLoadingCompleted => _isLoadingCompleted;

  bool get showSearchField => _showSearchField;

  bool get hideAppBar => _hideAppBar;

  bool get searchForUser => _searchForUser;

  List<ImageInfoEntity> get imagesInfoEntitiesList => _imagesInfoEntitiesList;
}
