import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_state.dart';
import 'package:unsplash_client_the_sequel/app/scene/home/home_screen.dart';
import 'package:unsplash_client_the_sequel/app/scene/picture_preview/picture_preview_screen.dart';

class RootRouterDelegate extends RouterDelegate<RouterState> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final Store<RouterState> _routerStore;

  RootRouterDelegate(
      GlobalKey<NavigatorState> navigatorKey, Store<RouterState> routerStore)
      : _navigatorKey = navigatorKey,
        _routerStore = routerStore;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: List.from(_extraPages),
        onPopPage: _onPopPageParser,
      );

  bool _onPopPageParser(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  List<Page> get _extraPages {
    return [
      MaterialPage(
        child: ScreenHome(),
      ),
      ..._finalPage()
    ];
  }

  List<Page> _finalPage() {
    if (_routerStore.state is PicturePreviewScreenRouterState) {
      return [
        const MaterialPage(
          child: ScreenPicturePreview(),
        ),
      ];
    }

    return [];
  }

  @override
  Future<bool> popRoute() async {
    switch (_routerStore.state.runtimeType) {
      default:
        RouterRedux.goToHomeScreen(_routerStore);
        break;
    }
    return true;
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(RouterState configuration) async {}
}
