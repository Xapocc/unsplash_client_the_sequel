import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_state.dart';

enum Actions {
  goToPicturePreviewScreen,
  goToHomeScreen,
}

abstract class RouterRedux {
  static Store<RouterState> get newStore => Store<RouterState>(
        RouterRedux.reducer,
        initialState: HomeScreenRouterState(),
      );

  static RouterState reducer(RouterState state, dynamic action) {
    if(action is String) {
      return PicturePreviewScreenRouterState(action);
    }

    if(action == Actions.goToHomeScreen) {
      return HomeScreenRouterState();
    }

    return HomeScreenRouterState();
  }

  static void goToHomeScreen(Store<RouterState> store) {
    store.dispatch(Actions.goToHomeScreen);
  }

  static void goToPicturePreviewScreen(Store<RouterState> store, String pictureUrl) {
    store.dispatch(pictureUrl);
  }
}
