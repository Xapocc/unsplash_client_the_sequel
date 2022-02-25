import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:unsplash_client_the_sequel/app/home/redux/home_screen_redux.dart';
import 'package:unsplash_client_the_sequel/app/home/redux/home_screen_state.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<HomeScreenState>(
      store: HomeScreenRedux.newStore,
      child: StoreConnector<HomeScreenState, HomeScreenState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return state.isLoadingCompleted
              ? dataScreen(context, state)
              : loadingScreen();
        },
      ),
    );
  }

  Widget dataScreen(BuildContext context, HomeScreenState state) {
    return Container(
      color: Colors.black12,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          mainListView(state),
          navigationButtons(context),
        ],
      ),
    );
  }

  Widget loadingScreen() {
    return StoreConnector<HomeScreenState, VoidCallback>(
      converter: (store) => () => HomeScreenRedux.loadPage(store),
      builder: (context, callback) {
        callback();

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black87,
          ),
        );
      },
    );
  }

  Widget mainListView(HomeScreenState state) {
    int listLength = state.imagesInfoEntitiesList.length;

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: listLength,
      itemBuilder: (BuildContext context, int index) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (index == 0) homeAppBar(),
          imageCard(state, index),
          if (index == listLength - 1)
            Container(height: MediaQuery.of(context).size.width * 0.15),
        ],
      ),
    );
  }

  Widget imageCard(HomeScreenState state, int index) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(state.imagesInfoEntitiesList[index].urlSmall,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingEvent) {
              if (loadingEvent == null) return child;
              return const Center(
                child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator()),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 15,
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                        state.imagesInfoEntitiesList[index].userPpLarge),
                  ),
                ),
                Expanded(
                  flex: 85,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.imagesInfoEntitiesList[index].username,
                          style: const TextStyle(
                              inherit: false,
                              color: Colors.black54,
                              fontSize: 18.0),
                        ),
                        Text(
                          "[${state.imagesInfoEntitiesList[index].userUsername}]",
                          style: const TextStyle(
                              inherit: false,
                              color: Colors.black26,
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navigationButtons(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        inherit: false, fontWeight: FontWeight.bold, fontSize: 20.0);

    return Container(
      height: MediaQuery.of(context).size.width * 0.15,
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navigationButton(HomeScreenActions.prevPageTurbo, "<<", textStyle),
          _navigationButton(HomeScreenActions.previousPage, "<", textStyle),
          StoreConnector<HomeScreenState, String>(
            converter: (store) => store.state.page.toString(),
            builder: (context, page) {
              return TextButton(
                child: Text(page, style: textStyle),
                onPressed: null,
              );
            },
          ),
          _navigationButton(HomeScreenActions.nextPage, ">", textStyle),
          _navigationButton(HomeScreenActions.nextPageTurbo, ">>", textStyle),
        ],
      ),
    );
  }

  Widget homeAppBar() {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.black87,
          shadowColor: Colors.transparent,
          centerTitle: false,
          title: const FittedBox(
            child: Text(
              "Unsplash Client: The Sequel",
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: StoreConnector<HomeScreenState, VoidCallback>(
                converter: (store) => () => HomeScreenRedux.dispatchAction(
                    store, HomeScreenActions.toggleSearchField),
                builder: (context, callback) => TextButton(
                  onPressed: callback,
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white12),
                    shape: MaterialStateProperty.resolveWith(
                      (states) => const CircleBorder(),
                    ),
                  ),
                  child: StoreConnector<HomeScreenState, bool>(
                    converter: (store) => store.state.showSearchField,
                    builder: (context, showSearchField) {
                      return showSearchField
                          ? const Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.white70,
                            )
                          : const Icon(
                              Icons.search,
                              color: Colors.white70,
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        StoreConnector<HomeScreenState, HomeScreenState>(
          converter: (store) => store.state,
          builder: (context, state) {
            TextEditingController searchController =
                TextEditingController(text: state.searchQuery);

            return state.showSearchField
                ? AppBar(
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    flexibleSpace: Row(
                      children: [
                        Expanded(
                          flex: 85,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, left: 8.0, right: 8.0),
                              child: TextField(
                                controller: searchController,
                                cursorColor: Colors.black87,
                                decoration: const InputDecoration(
                                  hintText: "Search for...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child:
                                  StoreConnector<HomeScreenState, VoidCallback>(
                                converter: (store) => () {
                                  HomeScreenRedux.dispatchNewSearch(
                                      store, searchController.text);
                                },
                                builder: (context, callback) => TextButton(
                                  style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black12),
                                      shape: MaterialStateProperty.resolveWith(
                                          (states) => const CircleBorder()),
                                      foregroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black87)),
                                  onPressed: callback,
                                  child: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }

  Widget _navigationButton(
      HomeScreenActions action, String text, TextStyle textStyle) {
    return StoreConnector<HomeScreenState, VoidCallback>(
      converter: (store) => () => HomeScreenRedux.dispatchAction(store, action),
      builder: (context, callback) {
        return TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white24),
            shape: MaterialStateProperty.resolveWith(
                (states) => const CircleBorder()),
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.white24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(text, style: textStyle),
          ),
          onPressed: callback,
        );
      },
    );
  }
}
