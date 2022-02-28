import 'package:unsplash_client_the_sequel/app/scene/home/redux/home_state.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';
import 'package:unsplash_client_the_sequel/main.dart';

enum HomeScreenActions {
  nextPage,
  previousPage,
  nextPageTurbo,
  prevPageTurbo,
  toggleSearchField,
}

abstract class HomeScreenRedux {
  static Store<HomeScreenState> get newStore => Store<HomeScreenState>(
        HomeScreenRedux.reducer,
        initialState: const HomeScreenState(),
      );

  static HomeScreenState reducer(HomeScreenState state, dynamic action) {
    if (action is HomeScreenState) {
      return action;
    }

    if (action == HomeScreenActions.nextPage) {
      return HomeScreenState.fromState(
        state,
        page: state.page + 1,
        isLoadingCompleted: false,
      );
    }
    if (action == HomeScreenActions.previousPage) {
      if (state.page == 1) return state;
      return HomeScreenState.fromState(
        state,
        page: state.page > 1 ? state.page - 1 : 1,
        isLoadingCompleted: false,
      );
    }

    if (action == HomeScreenActions.nextPageTurbo) {
      return HomeScreenState.fromState(
        state,
        page: state.page + 100,
        isLoadingCompleted: false,
      );
    }
    if (action == HomeScreenActions.prevPageTurbo) {
      if (state.page == 1) return state;
      return HomeScreenState.fromState(
        state,
        page: state.page > 101 ? state.page - 100 : 1,
        isLoadingCompleted: false,
      );
    }

    if (action == HomeScreenActions.toggleSearchField) {
      return HomeScreenState.fromState(
        state,
        showSearchField: !state.showSearchField,
      );
    }

    return state;
  }

  static void loadPage(Store<HomeScreenState> store) async {
    List<ImageInfoEntity> list = await imagesPageUseCase.getImagesPage(
      page: store.state.page,
      query: store.state.searchQuery,
    );

    store.dispatch(HomeScreenState.fromState(store.state,
        imagesInfoEntitiesList: list, isLoadingCompleted: true));
  }

  static void dispatchAction(
      Store<HomeScreenState> store, HomeScreenActions action) {
    store.dispatch(action);
  }

  static void dispatchNewSearch(
      Store<HomeScreenState> store, String? searchQuery) {
    store.dispatch(HomeScreenState.fromState(
      store.state,
      searchQuery: searchQuery,
      isLoadingCompleted: false,
      page: 1,
    ));
  }
}
