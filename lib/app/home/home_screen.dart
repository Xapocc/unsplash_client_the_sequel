import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/home/search_query_parameters.dart';

enum Actions {
  nextPage,
  previousPage,
}

SearchQueryParams pageReducer(SearchQueryParams state, dynamic action) {
  if (action == Actions.nextPage) {
    return SearchQueryParams(state.searchQuery, state.page + 1);
  }
  if (action == Actions.previousPage) {
    return SearchQueryParams(state.searchQuery, state.page - 1);
  }

  return state;
}

final store = Store<SearchQueryParams>(pageReducer,
    initialState: const SearchQueryParams("", 1));

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<SearchQueryParams>(
      store: store,
      child: Container(
        color: Colors.grey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StoreConnector<SearchQueryParams, VoidCallback>(
                converter: (store) =>
                    () => store.dispatch(Actions.previousPage),
                builder: (context, callback) {
                  return TextButton(
                      onPressed: callback, child: const Text("-"));
                },
              ),
              StoreConnector<SearchQueryParams, String>(
                  converter: (store) => store.state.page.toString(),
                  builder: (context, page) {
                    return Text(page);
                  }),
              StoreConnector<SearchQueryParams, VoidCallback>(
                converter: (store) => () => store.dispatch(Actions.nextPage),
                builder: (context, callback) {
                  return TextButton(
                      onPressed: callback, child: const Text("+"));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
