import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_delegate.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_state.dart';

class AppRoot extends StatelessWidget {
  AppRoot({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: RouterRedux.newStore,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Container(
            color: Colors.white,
            child: StoreConnector<RouterState, Store<RouterState>>(
              converter: (store) => store,
              builder: (context, store) {
                return Router(
                  routerDelegate: RootRouterDelegate(
                    navigatorKey,
                    store,
                  ),
                  backButtonDispatcher: RootBackButtonDispatcher(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
