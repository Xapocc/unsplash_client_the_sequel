import 'dart:convert';

import 'package:http/http.dart';
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
        ? await get(Uri.parse(
            'https://api.unsplash.com/photos?page=$page&per_page=$perPage&client_id=$apiKey'))
        : searchForUser
            ? await get(Uri.parse(
                'https://api.unsplash.com/users/$query/photos?page=$page&per_page=$perPage&client_id=$apiKey'))
            : await get(Uri.parse(
                'https://api.unsplash.com/search/photos?page=$page&query=$query&per_page=$perPage&client_id=$apiKey'));

    isQueryEmpty = isQueryEmpty || searchForUser;

    dynamic jsonResponse = jsonDecode(response.body);
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

    List<ImageInfoEntity> imageInfoEntitiesList = [];

    for (ImageInfoModel model in models) {
      imageInfoEntitiesList.add(ImageInfoMapper.map(model));
    }

    return imageInfoEntitiesList;
  }
}

var mockResponse = {
  "total": 10000,
  "total_pages": 5000,
  "results": [
    {
      "id": "rW-I87aPY5Y",
      "created_at": "2018-05-14T18:15:19-04:00",
      "updated_at": "2022-03-02T20:03:29-05:00",
      "promoted_at": "2018-05-15T08:30:56-04:00",
      "width": 3456,
      "height": 5184,
      "color": "#262626",
      "blur_hash": "LKCP;VMy0~iv8_\$e%2JBD*TfrqxG",
      "description": "Instant",
      "alt_description": "white butterfly resting on cat's nose",
      "urls": {
        "raw":
            "https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1",
        "full":
            "https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?crop=entropy\u0026cs=srgb\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=85",
        "regular":
            "https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=1080",
        "small":
            "https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=400",
        "thumb":
            "https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=200",
        "small_s3":
            "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1526336024174-e58f5cdd8e13"
      },
      "links": {
        "self": "https://api.unsplash.com/photos/rW-I87aPY5Y",
        "html": "https://unsplash.com/photos/rW-I87aPY5Y",
        "download":
            "https://unsplash.com/photos/rW-I87aPY5Y/download?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0",
        "download_location":
            "https://api.unsplash.com/photos/rW-I87aPY5Y/download?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwxfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0"
      },
      "categories": [],
      "likes": 5589,
      "liked_by_user": false,
      "current_user_collections": [],
      "sponsorship": null,
      "topic_submissions": {
        "wallpapers": {
          "status": "approved",
          "approved_on": "2020-07-01T08:54:52-04:00"
        },
        "animals": {
          "status": "approved",
          "approved_on": "2020-04-06T10:20:16-04:00"
        }
      },
      "user": {
        "id": "pxLaR4p8NQI",
        "updated_at": "2022-03-03T13:14:18-05:00",
        "username": "_k_arinn",
        "name": "Karina Vorozheeva",
        "first_name": "Karina Vorozheeva",
        "last_name": null,
        "twitter_username": null,
        "portfolio_url": null,
        "bio": null,
        "location": null,
        "links": {
          "self": "https://api.unsplash.com/users/_k_arinn",
          "html": "https://unsplash.com/@_k_arinn",
          "photos": "https://api.unsplash.com/users/_k_arinn/photos",
          "likes": "https://api.unsplash.com/users/_k_arinn/likes",
          "portfolio": "https://api.unsplash.com/users/_k_arinn/portfolio",
          "following": "https://api.unsplash.com/users/_k_arinn/following",
          "followers": "https://api.unsplash.com/users/_k_arinn/followers"
        },
        "profile_image": {
          "small":
              "https://images.unsplash.com/profile-1526335967228-92d2cd83b9ea?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
          "medium":
              "https://images.unsplash.com/profile-1526335967228-92d2cd83b9ea?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
          "large":
              "https://images.unsplash.com/profile-1526335967228-92d2cd83b9ea?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
        },
        "instagram_username": "_k_arinn",
        "total_collections": 0,
        "total_likes": 114,
        "total_photos": 98,
        "accepted_tos": true,
        "for_hire": false,
        "social": {
          "instagram_username": "_k_arinn",
          "portfolio_url": null,
          "twitter_username": null,
          "paypal_email": null
        }
      },
      "tags": [
        {
          "type": "landing_page",
          "title": "cat",
          "source": {
            "ancestry": {
              "type": {"slug": "images", "pretty_slug": "Images"},
              "category": {"slug": "animals", "pretty_slug": "Animals"},
              "subcategory": {"slug": "cat", "pretty_slug": "Cat"}
            },
            "title": "Cat Images \u0026 Pictures",
            "subtitle": "Download free cat images",
            "description":
                "9 lives isn't enough to capture the amazing-ness of cats. You need high-quality, professionally photographed images to do that. Unsplash's collection of cat images capture the wonder of the kitty in high-definition, and you can use these images however you wish for free.",
            "meta_title":
                "20+ Cat Pictures \u0026 Images [HD] | Download Free Images \u0026 Stock Photos on Unsplash",
            "meta_description":
                "Choose from hundreds of free cat pictures. Download HD cat photos for free on Unsplash.",
            "cover_photo": {
              "id": "_SMNO4cN9vs",
              "created_at": "2018-12-30T12:17:38-05:00",
              "updated_at": "2022-02-04T11:55:34-05:00",
              "promoted_at": "2019-01-01T05:23:58-05:00",
              "width": 4000,
              "height": 4000,
              "color": "#0c0c26",
              "blur_hash": "L012.;oL4=WBt6j@Rlay4;ay^iof",
              "description": "Glow in the Dark",
              "alt_description": "yellow eyes",
              "urls": {
                "raw":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1",
                "full":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=85\u0026fm=jpg\u0026crop=entropy\u0026cs=srgb",
                "regular":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max",
                "small":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=400\u0026fit=max",
                "thumb":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max",
                "small_s3":
                    "https://s3.us-west-2.amazonaws.com/images.unsplash.com/photo-1546190255-451a91afc548"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/_SMNO4cN9vs",
                "html": "https://unsplash.com/photos/_SMNO4cN9vs",
                "download": "https://unsplash.com/photos/_SMNO4cN9vs/download",
                "download_location":
                    "https://api.unsplash.com/photos/_SMNO4cN9vs/download"
              },
              "categories": [],
              "likes": 513,
              "liked_by_user": false,
              "current_user_collections": [],
              "sponsorship": null,
              "topic_submissions": {
                "animals": {
                  "status": "approved",
                  "approved_on": "2020-04-06T10:20:17-04:00"
                }
              },
              "user": {
                "id": "KlbPlQFM3j4",
                "updated_at": "2021-06-29T09:48:33-04:00",
                "username": "unlesbar_1608112_sink",
                "name": "Stephan Henning",
                "first_name": "Stephan",
                "last_name": "Henning",
                "twitter_username": null,
                "portfolio_url": null,
                "bio": null,
                "location": "Germany",
                "links": {
                  "self":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink",
                  "html": "https://unsplash.com/@unlesbar_1608112_sink",
                  "photos":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/photos",
                  "likes":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/likes",
                  "portfolio":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/portfolio",
                  "following":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/following",
                  "followers":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/followers"
                },
                "profile_image": {
                  "small":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
                  "medium":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
                  "large":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
                },
                "instagram_username": null,
                "total_collections": 3,
                "total_likes": 69,
                "total_photos": 0,
                "accepted_tos": true,
                "for_hire": false,
                "social": {
                  "instagram_username": null,
                  "portfolio_url": null,
                  "twitter_username": null,
                  "paypal_email": null
                }
              }
            }
          }
        },
        {
          "type": "landing_page",
          "title": "animal",
          "source": {
            "ancestry": {
              "type": {"slug": "images", "pretty_slug": "Images"},
              "category": {"slug": "animals", "pretty_slug": "Animals"}
            },
            "title": "Animals Images \u0026 Pictures",
            "subtitle": "Download free animals images",
            "description":
                "Passionate photographers have captured the most gorgeous animals in the world in their natural habitats and shared them with Unsplash. Now you can use these photos however you wish, for free!",
            "meta_title":
                "Best 20+ Animals Pictures [HD] | Download Free Images on Unsplash",
            "meta_description":
                "Choose from hundreds of free animals pictures. Download HD animals photos for free on Unsplash.",
            "cover_photo": {
              "id": "YozNeHM8MaA",
              "created_at": "2017-04-18T13:00:04-04:00",
              "updated_at": "2022-02-23T00:01:28-05:00",
              "promoted_at": "2017-04-19T13:54:55-04:00",
              "width": 5184,
              "height": 3456,
              "color": "#f3f3c0",
              "blur_hash": "LPR{0ext~pIU%MRQM{%M%LozIBM|",
              "description":
                  "I met this dude on safari in Kruger National park in northern South Africa. The giraffes were easily in my favorite creatures to witness. They seemed almost prehistoric the the way the graced the African plain.",
              "alt_description": "selective focus photography of giraffe",
              "urls": {
                "raw":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1",
                "full":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=85\u0026fm=jpg\u0026crop=entropy\u0026cs=srgb",
                "regular":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max",
                "small":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=400\u0026fit=max",
                "thumb":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max",
                "small_s3":
                    "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1492534513006-37715f336a39"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/YozNeHM8MaA",
                "html": "https://unsplash.com/photos/YozNeHM8MaA",
                "download": "https://unsplash.com/photos/YozNeHM8MaA/download",
                "download_location":
                    "https://api.unsplash.com/photos/YozNeHM8MaA/download"
              },
              "categories": [],
              "likes": 1486,
              "liked_by_user": false,
              "current_user_collections": [],
              "sponsorship": null,
              "topic_submissions": {
                "animals": {
                  "status": "approved",
                  "approved_on": "2021-06-09T11:10:40-04:00"
                }
              },
              "user": {
                "id": "J6cg9TA8-e8",
                "updated_at": "2022-02-13T16:16:37-05:00",
                "username": "judahlegge",
                "name": "Judah Legge",
                "first_name": "Judah",
                "last_name": "Legge",
                "twitter_username": null,
                "portfolio_url": null,
                "bio": null,
                "location": null,
                "links": {
                  "self": "https://api.unsplash.com/users/judahlegge",
                  "html": "https://unsplash.com/@judahlegge",
                  "photos": "https://api.unsplash.com/users/judahlegge/photos",
                  "likes": "https://api.unsplash.com/users/judahlegge/likes",
                  "portfolio":
                      "https://api.unsplash.com/users/judahlegge/portfolio",
                  "following":
                      "https://api.unsplash.com/users/judahlegge/following",
                  "followers":
                      "https://api.unsplash.com/users/judahlegge/followers"
                },
                "profile_image": {
                  "small":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
                  "medium":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
                  "large":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
                },
                "instagram_username": null,
                "total_collections": 0,
                "total_likes": 4,
                "total_photos": 1,
                "accepted_tos": false,
                "for_hire": false,
                "social": {
                  "instagram_username": null,
                  "portfolio_url": null,
                  "twitter_username": null,
                  "paypal_email": null
                }
              }
            }
          }
        },
        {
          "type": "landing_page",
          "title": "butterfly",
          "source": {
            "ancestry": {
              "type": {"slug": "images", "pretty_slug": "Images"},
              "category": {"slug": "animals", "pretty_slug": "Animals"},
              "subcategory": {"slug": "butterfly", "pretty_slug": "Butterfly"}
            },
            "title": "Butterfly Images",
            "subtitle": "Download free butterfly images",
            "description":
                "Butterflies are some of the most uniquely beautiful creatures on earth, and they've infatuated some of history's greatest artists. They've also infatuated many in our amazing community of photographers, and Unsplash has a collection of butterfly images that's unparalleled in quality. Always free on Unsplash.",
            "meta_title":
                "100+ Butterfly Pictures [HQ] | Download Free Images on Unsplash",
            "meta_description":
                "Choose from hundreds of free butterfly pictures. Download HD butterfly photos for free on Unsplash.",
            "cover_photo": {
              "id": "BtoUjLUtPnQ",
              "created_at": "2016-08-01T23:11:00-04:00",
              "updated_at": "2022-02-25T18:00:48-05:00",
              "promoted_at": "2016-08-01T23:11:00-04:00",
              "width": 3973,
              "height": 2649,
              "color": "#8ca68c",
              "blur_hash": "LSJ@]kImb{0\$ctI:xFxVR.RQw]oI",
              "description": "Butterfly on yellow flowers",
              "alt_description": "butterfly perched on flower at daytime",
              "urls": {
                "raw":
                    "https://images.unsplash.com/photo-1470107355970-2ace9f20ab15?ixlib=rb-1.2.1",
                "full":
                    "https://images.unsplash.com/photo-1470107355970-2ace9f20ab15?ixlib=rb-1.2.1\u0026q=85\u0026fm=jpg\u0026crop=entropy\u0026cs=srgb",
                "regular":
                    "https://images.unsplash.com/photo-1470107355970-2ace9f20ab15?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max",
                "small":
                    "https://images.unsplash.com/photo-1470107355970-2ace9f20ab15?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=400\u0026fit=max",
                "thumb":
                    "https://images.unsplash.com/photo-1470107355970-2ace9f20ab15?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max",
                "small_s3":
                    "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1470107355970-2ace9f20ab15"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/BtoUjLUtPnQ",
                "html": "https://unsplash.com/photos/BtoUjLUtPnQ",
                "download": "https://unsplash.com/photos/BtoUjLUtPnQ/download",
                "download_location":
                    "https://api.unsplash.com/photos/BtoUjLUtPnQ/download"
              },
              "categories": [],
              "likes": 703,
              "liked_by_user": false,
              "current_user_collections": [],
              "sponsorship": null,
              "topic_submissions": {
                "animals": {
                  "status": "approved",
                  "approved_on": "2020-04-15T11:56:37-04:00"
                }
              },
              "user": {
                "id": "Z3rzEpQKBAE",
                "updated_at": "2022-02-26T13:54:55-05:00",
                "username": "borisworkshop",
                "name": "Boris  Smokrovic",
                "first_name": "Boris ",
                "last_name": "Smokrovic ",
                "twitter_username": null,
                "portfolio_url": "http://borissmokrovic.500px.com",
                "bio":
                    "HI I’M BORIS I was born somewhere, and then grew up. Along the way I started traveling; I lived in different counties and worked for different not so famous and not so important people. Then I ended up where I am now, Taiwan.",
                "location": "Taiwan ",
                "links": {
                  "self": "https://api.unsplash.com/users/borisworkshop",
                  "html": "https://unsplash.com/@borisworkshop",
                  "photos":
                      "https://api.unsplash.com/users/borisworkshop/photos",
                  "likes": "https://api.unsplash.com/users/borisworkshop/likes",
                  "portfolio":
                      "https://api.unsplash.com/users/borisworkshop/portfolio",
                  "following":
                      "https://api.unsplash.com/users/borisworkshop/following",
                  "followers":
                      "https://api.unsplash.com/users/borisworkshop/followers"
                },
                "profile_image": {
                  "small":
                      "https://images.unsplash.com/profile-1470119415572-4c671c554a9e?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
                  "medium":
                      "https://images.unsplash.com/profile-1470119415572-4c671c554a9e?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
                  "large":
                      "https://images.unsplash.com/profile-1470119415572-4c671c554a9e?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
                },
                "instagram_username": null,
                "total_collections": 0,
                "total_likes": 29,
                "total_photos": 113,
                "accepted_tos": true,
                "for_hire": false,
                "social": {
                  "instagram_username": null,
                  "portfolio_url": "http://borissmokrovic.500px.com",
                  "twitter_username": null,
                  "paypal_email": null
                }
              }
            }
          }
        }
      ]
    },
    {
      "id": "gKXKBY-C-Dk",
      "created_at": "2018-01-02T05:20:47-05:00",
      "updated_at": "2022-03-03T02:02:56-05:00",
      "promoted_at": null,
      "width": 5026,
      "height": 3458,
      "color": "#598c73",
      "blur_hash": "LDCtq6Me0_kp3mof%MofUwkp,cRP",
      "description":
          "Gipsy the Cat was sitting on a bookshelf one afternoon and just stared right at me, kinda saying: “Will you take a picture already?”",
      "alt_description":
          "black and white cat lying on brown bamboo chair inside room",
      "urls": {
        "raw":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1",
        "full":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?crop=entropy\u0026cs=srgb\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=85",
        "regular":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=1080",
        "small":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=400",
        "thumb":
            "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=200",
        "small_s3":
            "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1514888286974-6c03e2ca1dba"
      },
      "links": {
        "self": "https://api.unsplash.com/photos/gKXKBY-C-Dk",
        "html": "https://unsplash.com/photos/gKXKBY-C-Dk",
        "download":
            "https://unsplash.com/photos/gKXKBY-C-Dk/download?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0",
        "download_location":
            "https://api.unsplash.com/photos/gKXKBY-C-Dk/download?ixid=MnwzMDM5MTR8MHwxfHNlYXJjaHwyfHxjYXR8ZW58MHx8fHwxNjQ2MzMyNDg0"
      },
      "categories": [],
      "likes": 939,
      "liked_by_user": false,
      "current_user_collections": [],
      "sponsorship": null,
      "topic_submissions": {},
      "user": {
        "id": "wBu1hC4QlL0",
        "updated_at": "2022-03-03T11:59:12-05:00",
        "username": "madhatterzone",
        "name": "Manja Vitolic",
        "first_name": "Manja",
        "last_name": "Vitolic",
        "twitter_username": null,
        "portfolio_url": "https://www.instagram.com/makawee_photography/?hl=en",
        "bio": "https://www.instagram.com/makawee_photography/",
        "location": "Wiesbaden, Germany",
        "links": {
          "self": "https://api.unsplash.com/users/madhatterzone",
          "html": "https://unsplash.com/@madhatterzone",
          "photos": "https://api.unsplash.com/users/madhatterzone/photos",
          "likes": "https://api.unsplash.com/users/madhatterzone/likes",
          "portfolio": "https://api.unsplash.com/users/madhatterzone/portfolio",
          "following": "https://api.unsplash.com/users/madhatterzone/following",
          "followers": "https://api.unsplash.com/users/madhatterzone/followers"
        },
        "profile_image": {
          "small":
              "https://images.unsplash.com/profile-fb-1514888261-0e72294039e0.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
          "medium":
              "https://images.unsplash.com/profile-fb-1514888261-0e72294039e0.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
          "large":
              "https://images.unsplash.com/profile-fb-1514888261-0e72294039e0.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
        },
        "instagram_username": "makawee_photography",
        "total_collections": 0,
        "total_likes": 10,
        "total_photos": 65,
        "accepted_tos": true,
        "for_hire": true,
        "social": {
          "instagram_username": "makawee_photography",
          "portfolio_url":
              "https://www.instagram.com/makawee_photography/?hl=en",
          "twitter_username": null,
          "paypal_email": null
        }
      },
      "tags": [
        {
          "type": "landing_page",
          "title": "cat",
          "source": {
            "ancestry": {
              "type": {"slug": "images", "pretty_slug": "Images"},
              "category": {"slug": "animals", "pretty_slug": "Animals"},
              "subcategory": {"slug": "cat", "pretty_slug": "Cat"}
            },
            "title": "Cat Images \u0026 Pictures",
            "subtitle": "Download free cat images",
            "description":
                "9 lives isn't enough to capture the amazing-ness of cats. You need high-quality, professionally photographed images to do that. Unsplash's collection of cat images capture the wonder of the kitty in high-definition, and you can use these images however you wish for free.",
            "meta_title":
                "20+ Cat Pictures \u0026 Images [HD] | Download Free Images \u0026 Stock Photos on Unsplash",
            "meta_description":
                "Choose from hundreds of free cat pictures. Download HD cat photos for free on Unsplash.",
            "cover_photo": {
              "id": "_SMNO4cN9vs",
              "created_at": "2018-12-30T12:17:38-05:00",
              "updated_at": "2022-02-04T11:55:34-05:00",
              "promoted_at": "2019-01-01T05:23:58-05:00",
              "width": 4000,
              "height": 4000,
              "color": "#0c0c26",
              "blur_hash": "L012.;oL4=WBt6j@Rlay4;ay^iof",
              "description": "Glow in the Dark",
              "alt_description": "yellow eyes",
              "urls": {
                "raw":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1",
                "full":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=85\u0026fm=jpg\u0026crop=entropy\u0026cs=srgb",
                "regular":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max",
                "small":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=400\u0026fit=max",
                "thumb":
                    "https://images.unsplash.com/photo-1546190255-451a91afc548?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max",
                "small_s3":
                    "https://s3.us-west-2.amazonaws.com/images.unsplash.com/photo-1546190255-451a91afc548"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/_SMNO4cN9vs",
                "html": "https://unsplash.com/photos/_SMNO4cN9vs",
                "download": "https://unsplash.com/photos/_SMNO4cN9vs/download",
                "download_location":
                    "https://api.unsplash.com/photos/_SMNO4cN9vs/download"
              },
              "categories": [],
              "likes": 513,
              "liked_by_user": false,
              "current_user_collections": [],
              "sponsorship": null,
              "topic_submissions": {
                "animals": {
                  "status": "approved",
                  "approved_on": "2020-04-06T10:20:17-04:00"
                }
              },
              "user": {
                "id": "KlbPlQFM3j4",
                "updated_at": "2021-06-29T09:48:33-04:00",
                "username": "unlesbar_1608112_sink",
                "name": "Stephan Henning",
                "first_name": "Stephan",
                "last_name": "Henning",
                "twitter_username": null,
                "portfolio_url": null,
                "bio": null,
                "location": "Germany",
                "links": {
                  "self":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink",
                  "html": "https://unsplash.com/@unlesbar_1608112_sink",
                  "photos":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/photos",
                  "likes":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/likes",
                  "portfolio":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/portfolio",
                  "following":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/following",
                  "followers":
                      "https://api.unsplash.com/users/unlesbar_1608112_sink/followers"
                },
                "profile_image": {
                  "small":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
                  "medium":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
                  "large":
                      "https://images.unsplash.com/profile-1531167540173-a920494357e7?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
                },
                "instagram_username": null,
                "total_collections": 3,
                "total_likes": 69,
                "total_photos": 0,
                "accepted_tos": true,
                "for_hire": false,
                "social": {
                  "instagram_username": null,
                  "portfolio_url": null,
                  "twitter_username": null,
                  "paypal_email": null
                }
              }
            }
          }
        },
        {
          "type": "landing_page",
          "title": "animal",
          "source": {
            "ancestry": {
              "type": {"slug": "images", "pretty_slug": "Images"},
              "category": {"slug": "animals", "pretty_slug": "Animals"}
            },
            "title": "Animals Images \u0026 Pictures",
            "subtitle": "Download free animals images",
            "description":
                "Passionate photographers have captured the most gorgeous animals in the world in their natural habitats and shared them with Unsplash. Now you can use these photos however you wish, for free!",
            "meta_title":
                "Best 20+ Animals Pictures [HD] | Download Free Images on Unsplash",
            "meta_description":
                "Choose from hundreds of free animals pictures. Download HD animals photos for free on Unsplash.",
            "cover_photo": {
              "id": "YozNeHM8MaA",
              "created_at": "2017-04-18T13:00:04-04:00",
              "updated_at": "2022-02-23T00:01:28-05:00",
              "promoted_at": "2017-04-19T13:54:55-04:00",
              "width": 5184,
              "height": 3456,
              "color": "#f3f3c0",
              "blur_hash": "LPR{0ext~pIU%MRQM{%M%LozIBM|",
              "description":
                  "I met this dude on safari in Kruger National park in northern South Africa. The giraffes were easily in my favorite creatures to witness. They seemed almost prehistoric the the way the graced the African plain.",
              "alt_description": "selective focus photography of giraffe",
              "urls": {
                "raw":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1",
                "full":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=85\u0026fm=jpg\u0026crop=entropy\u0026cs=srgb",
                "regular":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=1080\u0026fit=max",
                "small":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=400\u0026fit=max",
                "thumb":
                    "https://images.unsplash.com/photo-1492534513006-37715f336a39?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=entropy\u0026cs=tinysrgb\u0026w=200\u0026fit=max",
                "small_s3":
                    "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1492534513006-37715f336a39"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/YozNeHM8MaA",
                "html": "https://unsplash.com/photos/YozNeHM8MaA",
                "download": "https://unsplash.com/photos/YozNeHM8MaA/download",
                "download_location":
                    "https://api.unsplash.com/photos/YozNeHM8MaA/download"
              },
              "categories": [],
              "likes": 1486,
              "liked_by_user": false,
              "current_user_collections": [],
              "sponsorship": null,
              "topic_submissions": {
                "animals": {
                  "status": "approved",
                  "approved_on": "2021-06-09T11:10:40-04:00"
                }
              },
              "user": {
                "id": "J6cg9TA8-e8",
                "updated_at": "2022-02-13T16:16:37-05:00",
                "username": "judahlegge",
                "name": "Judah Legge",
                "first_name": "Judah",
                "last_name": "Legge",
                "twitter_username": null,
                "portfolio_url": null,
                "bio": null,
                "location": null,
                "links": {
                  "self": "https://api.unsplash.com/users/judahlegge",
                  "html": "https://unsplash.com/@judahlegge",
                  "photos": "https://api.unsplash.com/users/judahlegge/photos",
                  "likes": "https://api.unsplash.com/users/judahlegge/likes",
                  "portfolio":
                      "https://api.unsplash.com/users/judahlegge/portfolio",
                  "following":
                      "https://api.unsplash.com/users/judahlegge/following",
                  "followers":
                      "https://api.unsplash.com/users/judahlegge/followers"
                },
                "profile_image": {
                  "small":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=32\u0026w=32",
                  "medium":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=64\u0026w=64",
                  "large":
                      "https://images.unsplash.com/profile-fb-1492532922-001f65e39343.jpg?ixlib=rb-1.2.1\u0026q=80\u0026fm=jpg\u0026crop=faces\u0026cs=tinysrgb\u0026fit=crop\u0026h=128\u0026w=128"
                },
                "instagram_username": null,
                "total_collections": 0,
                "total_likes": 4,
                "total_photos": 1,
                "accepted_tos": false,
                "for_hire": false,
                "social": {
                  "instagram_username": null,
                  "portfolio_url": null,
                  "twitter_username": null,
                  "paypal_email": null
                }
              }
            }
          }
        },
        {"type": "search", "title": "pet"}
      ]
    }
  ]
};
