import 'package:dio/dio.dart';
import 'package:unsplash_client_the_sequel/data/mappers/image_info_mapper.dart';
import 'package:unsplash_client_the_sequel/data/models/image_info_model.dart';
import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/images_page_repository_interface.dart';

class ImagesPageHttpRepositoryImpl implements IImagesPageRepository {
  @override
  Future<List<ImageInfoEntity>> getImagesPage({
    String? query,
    int page = 1,
    int perPage = 10,
    bool searchForUser = false,
  }) async {
    String apiKey = "oBQ_IOgOfAfvbXI505KO7onl2TL5b2hTsNBHS-NL7bI";

    bool isQueryEmpty = query == null || query.isEmpty;

    var response = isQueryEmpty
        ? await Dio().get(
            'https://api.unsplash.com/photos',
            queryParameters: {
              "page": page,
              "per_page": perPage,
              "client_id": apiKey
            },
          )
        : searchForUser
            ? await Dio().get(
                'https://api.unsplash.com/users/$query/photos',
                queryParameters: {
                  "page": page,
                  "per_page": perPage,
                  "client_id": apiKey
                },
              )
            : await Dio().get(
                'https://api.unsplash.com/search/photos',
                queryParameters: {
                  "page": page,
                  "query": query,
                  "per_page": perPage,
                  "client_id": apiKey
                },
              );

    isQueryEmpty = isQueryEmpty || searchForUser;

    dynamic jsonResponse = response.data;

    List<ImageInfoModel> models = [];

    for (Map<String, dynamic> item
        in isQueryEmpty ? jsonResponse : jsonResponse["results"]) {
      int width = item["width"];
      int height = item["height"];

      List<String> urls = [];
      for (String url in item["urls"].values) {
        urls.add(url);
      }

      String userUsername = item["user"]["username"];
      String username = item["user"]["name"];

      List<String> profilePictures = [];
      for (String pp in item["user"]["profile_image"].values) {
        profilePictures.add(pp);
      }

      models.add(ImageInfoModel(
        models.isEmpty && !isQueryEmpty ? jsonResponse["total_pages"] : null,
        width.toDouble(),
        height.toDouble(),
        urls[0],
        urls[1],
        urls[2],
        urls[3],
        urls[4],
        urls[5],
        userUsername,
        username,
        profilePictures[0],
        profilePictures[1],
        profilePictures[2],
      ));
    }

    if (models.length < perPage) {
      // end of search element
      models.add(
          ImageInfoModel(-1, 0, 0, "", "", "", "", "", "", "", "", "", "", ""));
    }

    List<ImageInfoEntity> imageInfoEntitiesList = [];

    for (ImageInfoModel model in models) {
      imageInfoEntitiesList.add(ImageInfoMapper.map(model));
    }

    return imageInfoEntitiesList;
  }
}
