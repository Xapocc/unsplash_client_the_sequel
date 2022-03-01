import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:unsplash_client_the_sequel/app/router/router_redux/router_state.dart';

class ScreenPicturePreview extends StatelessWidget {
  const ScreenPicturePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: StoreConnector<RouterState, String>(
          converter: (store) => store.state is PicturePreviewScreenRouterState
              ? (store.state as PicturePreviewScreenRouterState).pictureUrl
              : "",
          builder: (context, url) {
            if (url.isEmpty) return Container();
            return Image.network(url);
          },
        ),
      ),
    );
  }
}
