import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';

class HomeScreenState {
  const HomeScreenState(
      {String? searchQuery,
      int page = 1,
      bool isLoadingCompleted = false,
      List<ImageInfoEntity> imagesInfoEntitiesList = const []})
      : _searchQuery = searchQuery,
        _page = page,
        _isLoadingCompleted = isLoadingCompleted,
        _imagesInfoEntitiesList = imagesInfoEntitiesList;

  HomeScreenState.fromState(HomeScreenState state,
      {String? searchQuery,
      int? page,
      bool? isLoadingCompleted,
      List<ImageInfoEntity>? imagesInfoEntitiesList})
      : _searchQuery = searchQuery ?? state.searchQuery,
        _page = page ?? state.page,
        _isLoadingCompleted = isLoadingCompleted ?? state.isLoadingCompleted,
        _imagesInfoEntitiesList =
            imagesInfoEntitiesList ?? state.imagesInfoEntitiesList;

  final String? _searchQuery;
  final int _page;
  final bool _isLoadingCompleted;
  final List<ImageInfoEntity> _imagesInfoEntitiesList;

  String? get searchQuery => _searchQuery;

  int get page => _page;

  bool get isLoadingCompleted => _isLoadingCompleted;

  List<ImageInfoEntity> get imagesInfoEntitiesList => _imagesInfoEntitiesList;
}
