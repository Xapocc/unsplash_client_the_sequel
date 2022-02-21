import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/home/home_screen_state.dart';
import 'package:unsplash_client_the_sequel/main.dart';

enum Actions {
  nextPage,
  previousPage,
}

HomeScreenState pageReducer(HomeScreenState state, dynamic action) {
  if (action is HomeScreenState) {
    return action;
  }

  if (action == Actions.nextPage) {
    return HomeScreenState.fromState(state, page: state.page + 1);
  }
  if (action == Actions.previousPage) {
    return HomeScreenState.fromState(state, page: state.page + 1);
  }

  return state;
}

final store = Store<HomeScreenState>(pageReducer,
    initialState: const HomeScreenState(null, 1));

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
    );
  }
}

/* return StoreProvider<HomeScreenState>(
      store: store,
      child: Container(
        color: Colors.grey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoreConnector<HomeScreenState, VoidCallback>(
                converter: (store) => () {
                  imagesPageUseCase.getImagesPage(page: 2, perPage: 10);
                  store.dispatch(HomeScreenState.fromState(store.state,
                      searchQuery: "cat"));
                },
                builder: (context, callback) {
                  print(store.state.searchQuery);

                  return TextButton(
                      onPressed: callback, child: const Text("-"));
                },
              ),
              StoreConnector<HomeScreenState, String>(
                converter: (store) => store.state.page.toString(),
                builder: (context, page) {
                  return Text(
                    "Page: ${store.state.page} searchQuery: ${store.state.searchQuery}",
                    style: const TextStyle(inherit: false),
                  );
                },
              ),
              StoreConnector<HomeScreenState, VoidCallback>(
                converter: (store) => () {
                  store.dispatch(HomeScreenState.fromState(store.state,
                      searchQuery: "doggo"));
                },
                builder: (context, callback) {
                  return TextButton(
                      onPressed: callback, child: const Text("+"));
                },
              ),
            ],
          ),
        ),
      ),
    );*/
