import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/home/home_screen_state.dart';
import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';
import 'package:unsplash_client_the_sequel/main.dart';

enum Actions {
  nextPage,
  previousPage,
  nextPageTurbo,
  prevPageTurbo,
}

HomeScreenState homeReducer(HomeScreenState state, dynamic action) {
  if (action is HomeScreenState) {
    return action;
  }

  if (action == Actions.nextPage) {
    return HomeScreenState.fromState(
      state,
      page: state.page + 1,
      isLoadingCompleted: false,
    );
  }
  if (action == Actions.previousPage) {
    if (state.page == 1) return state;
    return HomeScreenState.fromState(
      state,
      page: state.page > 1 ? state.page - 1 : 1,
      isLoadingCompleted: false,
    );
  }

  if (action == Actions.nextPageTurbo) {
    return HomeScreenState.fromState(
      state,
      page: state.page + 100,
      isLoadingCompleted: false,
    );
  }
  if (action == Actions.prevPageTurbo) {
    if (state.page == 1) return state;
    return HomeScreenState.fromState(
      state,
      page: state.page > 101 ? state.page - 100 : 1,
      isLoadingCompleted: false,
    );
  }

  return state;
}

final store =
Store<HomeScreenState>(homeReducer, initialState: const HomeScreenState());

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StoreProvider<HomeScreenState>(
      store: store,
      child: StoreConnector<HomeScreenState, bool>(
        converter: (store) => store.state.isLoadingCompleted,
        builder: (context, isLoadingCompleted) {
          return store.state.isLoadingCompleted
              ? Container(
            color: Colors.black12,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                mainListView(),
                navigationButtons(context),
              ],
            ),
          )
              : StoreConnector<HomeScreenState, VoidCallback>(
            converter: (store) =>
                () async {
              List<ImageInfoEntity> list = await imagesPageUseCase
                  .getImagesPage(page: store.state.page);

              store.dispatch(HomeScreenState.fromState(store.state,
                  imagesInfoEntitiesList: list,
                  isLoadingCompleted: true));
            },
            builder: (context, callback) {
              callback();

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }

  Widget mainListView() {
    int listLength = store.state.imagesInfoEntitiesList.length;

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      itemCount: listLength,
      itemBuilder: (BuildContext context, int index) =>
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (index == 0) homeAppBar(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: store.state.imagesInfoEntitiesList[index]
                        .width /
                        store.state.imagesInfoEntitiesList[index].height,
                    child: Image.network(
                      store.state.imagesInfoEntitiesList[index].urlSmall,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(store
                              .state.imagesInfoEntitiesList[index].userPpLarge),
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
                                store.state.imagesInfoEntitiesList[index]
                                    .username,
                                style: const TextStyle(
                                    inherit: false,
                                    color: Colors.black54,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "[${store.state.imagesInfoEntitiesList[index]
                                    .userUsername}]",
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
                if (index == listLength - 1)
                  Container(height: MediaQuery
                      .of(context)
                      .size
                      .width * 0.15),
              ],
            ),
          ),
    );
  }

  Widget navigationButtons(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        inherit: false, fontWeight: FontWeight.bold, fontSize: 20.0);

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .width * 0.15,
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navigationButton(Actions.prevPageTurbo, "<<", textStyle),
          _navigationButton(Actions.previousPage, "<", textStyle),
          StoreConnector<HomeScreenState, String>(
            converter: (store) => store.state.page.toString(),
            builder: (context, page) {
              return TextButton(
                child: Text(page, style: textStyle),
                onPressed: null,
              );
            },
          ),
          _navigationButton(Actions.nextPage, ">", textStyle),
          _navigationButton(Actions.nextPageTurbo, ">>", textStyle),
        ],
      ),
    );
  }

  Widget homeAppBar() {
    return AppBar(
      backgroundColor: Colors.black87,
      shadowColor: Colors.transparent,
      centerTitle: false,
      title: const Text(
        "Unsplash Client: The Sequel",
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _navigationButton(Actions action, String text, TextStyle textStyle) {
    return StoreConnector<HomeScreenState, VoidCallback>(
      converter: (store) =>
          () async {
        store.dispatch(action);
      },
      builder: (context, callback) {
        return TextButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white24),
              shape: MaterialStateProperty.resolveWith((states) => const CircleBorder()),
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white24),
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
