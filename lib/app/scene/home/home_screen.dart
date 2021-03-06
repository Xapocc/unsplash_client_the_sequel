import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_state.dart';
import 'package:unsplash_client_the_sequel/app/scene/home/redux/home_redux.dart';
import 'package:unsplash_client_the_sequel/app/scene/home/redux/home_state.dart';

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
    ScrollController sharedController = ScrollController();

    return Container(
      color: Colors.black12,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          mainListView(context, state, sharedController),
          navigationBar(context, state),
          Align(
            alignment: Alignment.topCenter,
            child: homeAppBar(context, state, sharedController),
          ),
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

  Widget mainListView(BuildContext context, HomeScreenState state,
      ScrollController sharedController) {
    ScrollController controller = ScrollController();

    double offset = 0;

    controller.addListener(
      () {
        if (!controller.hasClients) return;

        if (sharedController.hasClients) {
          double newOffset =
              sharedController.offset - (offset - controller.offset);
          newOffset = newOffset.clamp(0, 56 * (state.showSearchField ? 2 : 1));

          sharedController.jumpTo(newOffset);

        }

        offset = controller.offset;
      },
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation.index == 0;

        List<List<int>> separatedLists =
            isPortrait ? [] : listSeparation(state);

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: controller,
          child: isPortrait
              ? Column(
                  children: getImagesSublist(state),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: getImagesSublist(state, separatedLists.first),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: getImagesSublist(state, separatedLists.last),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  List<Widget> getImagesSublist(HomeScreenState state,
      [List<int> indexes = const []]) {
    int totalLength = state.imagesInfoEntitiesList.length;

    List<Widget> list = [];

    for (int i = 0; i < totalLength; i++) {
      if (indexes.isNotEmpty && !indexes.contains(i)) continue;

      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (list.isEmpty && !state.hideAppBar)
              SizedBox(
                height: AppBar().preferredSize.height,
              ),
            imageCard(state, i),
          ],
        ),
      );
    }

    list.add(Container(height: AppBar().preferredSize.height));

    return list;
  }

  List<List<int>> listSeparation(HomeScreenState state) {
    var initialList = state.imagesInfoEntitiesList;
    List<int> firstList = [];
    List<int> secondList = [];

    double first = 0, second = 0;

    first += initialList.first.height / initialList.first.width;
    firstList.add(0);

    for (int i = 1; i < initialList.length; i++) {
      if (first < second) {
        first +=
            initialList.elementAt(i).height / initialList.elementAt(i).width;
        firstList.add(i);
      } else {
        second +=
            initialList.elementAt(i).height / initialList.elementAt(i).width;
        secondList.add(i);
      }
    }

    return [firstList, secondList];
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
      child: imageCardContent(state, index),
    );
  }

  Widget imageCardContent(HomeScreenState state, int index) {
    if ((state.imagesInfoEntitiesList[index].maxPages ?? 1) <= 0) {
      return endOfSearchCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        imageCardMainImage(state, index),
        imageCardUserRow(state, index),
      ],
    );
  }

  Widget imageCardMainImage(HomeScreenState state, int index) {
    var itemEntity = state.imagesInfoEntitiesList[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StoreConnector<RouterState, VoidCallback>(
        converter: (store) => () =>
            RouterRedux.goToPicturePreviewScreen(store, itemEntity.urlFull),
        builder: (context, callback) => TextButton(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
          onPressed: callback,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                itemEntity.urlSmall,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingEvent) {
                  if (loadingEvent == null) return child;
                  return AspectRatio(
                    aspectRatio: itemEntity.width / itemEntity.height,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageCardUserRow(HomeScreenState state, int index) {
    return StoreConnector<HomeScreenState, VoidCallback>(
      converter: (store) => () => HomeScreenRedux.dispatchNewUserSearch(
          store, state.imagesInfoEntitiesList[index].userUsername),
      builder: (context, callback) => TextButton(
        onPressed: callback,
        style: ButtonStyle(
          padding:
              MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
        ),
        child: Padding(
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
                    state.imagesInfoEntitiesList[index].userPpLarge,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 75,
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
              Expanded(
                flex: 10,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      const FittedBox(
                        child: Icon(
                          Icons.download,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.zero),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black26),
                        ),
                        onPressed: () async {
                          Fluttertoast.showToast(
                              msg: await HomeScreenRedux.downloadImage(
                                  state.imagesInfoEntitiesList[index].urlFull));
                        },
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget endOfSearchCard() {
    TextStyle textStyle =
        const TextStyle(inherit: false, color: Colors.black, fontSize: 24.0);

    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FractionallySizedBox(
              widthFactor: 0.3,
              child: FittedBox(
                child: Icon(Icons.wallpaper),
              ),
            ),
            Text(
              "There is no more images\nfor your search.",
              style: textStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              "Try changing the search\nquery to find more.",
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget navigationBar(BuildContext context, HomeScreenState state) {
    TextStyle textStyle = const TextStyle(
        inherit: false, fontWeight: FontWeight.bold, fontSize: 20.0);

    TextStyle textStylePage1 = const TextStyle(
      inherit: false,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    TextStyle textStylePage2 = const TextStyle(
      inherit: false,
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
    );

    int? maxPages = state.imagesInfoEntitiesList.isNotEmpty
        ? state.imagesInfoEntitiesList.first.maxPages
        : null;

    return Container(
      height: AppBar().preferredSize.height,
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navigationButton(HomeScreenActions.prevPageTurbo, "<<", textStyle),
          _navigationButton(HomeScreenActions.previousPage, "<", textStyle),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white24, Colors.black12],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              shape: BoxShape.circle,
            ),
            child: TextButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${state.page}", style: textStylePage1),
                  if ((maxPages ?? -1) > 0)
                    Text("$maxPages", style: textStylePage2),
                ],
              ),
              onPressed: null,
            ),
          ),
          _navigationButton(HomeScreenActions.nextPage, ">", textStyle),
          _navigationButton(HomeScreenActions.nextPageTurbo, ">>", textStyle),
        ],
      ),
    );
  }

  Widget homeAppBar(BuildContext context, HomeScreenState state,
      ScrollController sharedController) {
    return SizedBox(
      height: AppBar().preferredSize.height * (state.showSearchField ? 2 : 1),
      child: SingleChildScrollView(
        controller: sharedController,
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: AppBar().preferredSize.height * 4,
          child: Column(
            children: [
              homeAppBarMain(state),
              homeAppBarSearch(),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeAppBarMain(HomeScreenState state) {
    return AppBar(
      backgroundColor: Colors.black87,
      shadowColor: Colors.transparent,
      centerTitle: false,
      leading: homeAppBarCleanQueryButton(
          state.searchQuery != null && state.searchQuery!.isNotEmpty),
      title: FittedBox(
        child: Text(
          state.searchQuery?.isEmpty ?? true
              ? "Unsplash Client: The Sequel"
              : "${state.searchForUser ? "User" : "Search"}: ${state.searchQuery}",
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold),
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
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.white12),
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
    );
  }

  Widget? homeAppBarCleanQueryButton(bool show) {
    return show
        ? StoreConnector<HomeScreenState, VoidCallback>(
            converter: (store) => () {
              HomeScreenRedux.dispatchNewSearch(store, "");
            },
            builder: (context, callback) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white12),
                  shape: MaterialStateProperty.resolveWith(
                    (states) => const CircleBorder(),
                  ),
                ),
                onPressed: callback,
                child: const Icon(
                  Icons.close,
                  color: Colors.white70,
                ),
              ),
            ),
          )
        : null;
  }

  Widget homeAppBarSearch() {
    return StoreConnector<HomeScreenState, HomeScreenState>(
      converter: (store) => store.state,
      builder: (context, state) {
        TextEditingController searchController =
            TextEditingController(text: state.searchQuery);

        searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: searchController.text.length));

        return state.showSearchField
            ? AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                flexibleSpace: StoreConnector<HomeScreenState, VoidCallback>(
                  converter: (store) => () {
                    HomeScreenRedux.dispatchNewSearch(
                        store, searchController.text);
                  },
                  builder: (context, callback) => SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 20,
                          child: StoreConnector<HomeScreenState, VoidCallback>(
                            converter: (store) =>
                                () => HomeScreenRedux.turnSearchMode(store),
                            builder: (context, callback) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FittedBox(
                                  child: DropdownButton<String>(
                                    value:
                                        state.searchForUser ? "User" : "Search",
                                    icon: const Icon(Icons.arrow_drop_down),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      String currentValue = state.searchForUser
                                          ? "User"
                                          : "Search";

                                      if (newValue != currentValue) callback();
                                    },
                                    items: ["Search", "User"]
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                ))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 70,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, left: 8.0, right: 8.0),
                              child: TextField(
                                onEditingComplete: callback,
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
                              child: TextButton(
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
                      ],
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget _navigationButton(
      HomeScreenActions action, String text, TextStyle textStyle) {
    return StoreConnector<HomeScreenState, VoidCallback>(
      converter: (store) => () => HomeScreenRedux.dispatchAction(store, action),
      builder: (context, callback) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white24, Colors.black12],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            shape: BoxShape.circle,
          ),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
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
          ),
        );
      },
    );
  }
}

//
// Widget mainListView(HomeScreenState state) {
//   return StoreConnector<HomeScreenState, VoidCallback>(
//     converter: (store) => () => HomeScreenRedux.turnAppBar(store),
//     builder: (context, callback) {
//       ScrollController controller = ScrollController();
//
//       int listLength = state.imagesInfoEntitiesList.length;
//
//       controller.addListener(() {
//         if (!controller.hasClients) return;
//
//         if (controller.position.userScrollDirection.name == "reverse" &&
//             state.hideAppBar == false) {
//           callback();
//         }
//
//         if (controller.position.userScrollDirection.name == "forward" &&
//             state.hideAppBar == true) {
//           callback();
//         }
//       });
//
//       return OrientationBuilder(builder: (context, orientation) {
//         bool isPortrait = orientation.index == 0;
//
//         return Row(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller: controller,
//                 physics: const ClampingScrollPhysics(),
//                 itemCount: listLength,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       if (index == 0 && !state.hideAppBar)
//                         SizedBox(
//                           height: AppBar().preferredSize.height *
//                               (state.showSearchField ? 2 : 1),
//                         ),
//                       imageCard(state, index),
//                       if (index == listLength - 1)
//                         Container(height: AppBar().preferredSize.height),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 controller: controller,
//                 physics: const ClampingScrollPhysics(),
//                 itemCount: listLength,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       if (index == 0 && !state.hideAppBar)
//                         SizedBox(
//                           height: AppBar().preferredSize.height *
//                               (state.showSearchField ? 2 : 1),
//                         ),
//                       imageCard(state, index),
//                       if (index == listLength - 1)
//                         Container(height: AppBar().preferredSize.height),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       });
//     },
//   );
// }
