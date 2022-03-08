import 'package:get_it/get_it.dart';
import 'package:unsplash_client_the_sequel/app/scene/home/redux/home_state.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';
import 'package:unsplash_client_the_sequel/domain/use_cases/Images_page_use_case.dart';

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
      if ((state.imagesInfoEntitiesList.last.maxPages ?? 1) < 0) return state;

      if (state.page == state.imagesInfoEntitiesList.first.maxPages) {
        return state;
      }

      return HomeScreenState.fromState(
        state,
        page: state.page + 1,
        isLoadingCompleted: false,
        showSearchField: false,
        hideAppBar: false,
      );
    }
    if (action == HomeScreenActions.previousPage) {
      if (state.page == 1) return state;
      return HomeScreenState.fromState(
        state,
        page: state.page > 1 ? state.page - 1 : 1,
        isLoadingCompleted: false,
        showSearchField: false,
        hideAppBar: false,
      );
    }

    if (action == HomeScreenActions.nextPageTurbo) {
      if ((state.imagesInfoEntitiesList.last.maxPages ?? 1) < 0) return state;

      if (state.imagesInfoEntitiesList.first.maxPages != null) {
        if (state.page == state.imagesInfoEntitiesList.first.maxPages!) {
          return state;
        }

        if (state.page > state.imagesInfoEntitiesList.first.maxPages! - 100) {
          return HomeScreenState.fromState(
            state,
            page: state.imagesInfoEntitiesList.first.maxPages,
            isLoadingCompleted: false,
            showSearchField: false,
            hideAppBar: false,
          );
        }
      }

      return HomeScreenState.fromState(
        state,
        page: state.page + 100,
        isLoadingCompleted: false,
        showSearchField: false,
        hideAppBar: false,
      );
    }
    if (action == HomeScreenActions.prevPageTurbo) {
      if (state.page == 1) return state;
      return HomeScreenState.fromState(
        state,
        page: state.page > 101 ? state.page - 100 : 1,
        isLoadingCompleted: false,
        showSearchField: false,
        hideAppBar: false,
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
    List<ImageInfoEntity> list =
        await GetIt.I<ImagesPageUseCase>().getImagesPage(
      page: store.state.page,
      query: store.state.searchQuery,
      perPage: 25,
      searchForUser: store.state.searchForUser,
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

  static void dispatchNewUserSearch(
      Store<HomeScreenState> store, String? searchQuery) {
    store.dispatch(HomeScreenState.fromState(
      store.state,
      searchQuery: searchQuery,
      isLoadingCompleted: false,
      page: 1,
      searchForUser: true,
    ));
  }

  static void turnAppBar(Store<HomeScreenState> store) {
    store.dispatch(HomeScreenState.fromState(
      store.state,
      hideAppBar: !store.state.hideAppBar,
      showSearchField: false,
    ));
  }

  static void turnSearchMode(Store<HomeScreenState> store) {
    store.dispatch(HomeScreenState.fromState(
      store.state,
      searchForUser: !store.state.searchForUser,
    ));
  }
}
