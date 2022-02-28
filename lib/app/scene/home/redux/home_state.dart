import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';

class HomeScreenState {
  const HomeScreenState(
      {String? searchQuery,
      int page = 1,
      bool isLoadingCompleted = false,
      bool showSearchField = false,
      List<ImageInfoEntity> imagesInfoEntitiesList = const []})
      : _searchQuery = searchQuery,
        _page = page,
        _isLoadingCompleted = isLoadingCompleted,
        _showSearchField = showSearchField,
        _imagesInfoEntitiesList = imagesInfoEntitiesList;

  HomeScreenState.fromState(HomeScreenState state,
      {String? searchQuery,
      int? page,
      bool? isLoadingCompleted,
      bool? showSearchField,
      List<ImageInfoEntity>? imagesInfoEntitiesList})
      : _searchQuery = searchQuery ?? state.searchQuery,
        _page = page ?? state.page,
        _isLoadingCompleted = isLoadingCompleted ?? state.isLoadingCompleted,
        _showSearchField = showSearchField ?? state.showSearchField,
        _imagesInfoEntitiesList =
            imagesInfoEntitiesList ?? state.imagesInfoEntitiesList;

  final String? _searchQuery;
  final int _page;
  final bool _isLoadingCompleted;
  final bool _showSearchField;
  final List<ImageInfoEntity> _imagesInfoEntitiesList;

  String? get searchQuery => _searchQuery;

  int get page => _page;

  bool get isLoadingCompleted => _isLoadingCompleted;

  bool get showSearchField => _showSearchField;

  List<ImageInfoEntity> get imagesInfoEntitiesList => _imagesInfoEntitiesList;
}