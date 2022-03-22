import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unsplash_client_the_sequel/data/mappers/download_image_mapper.dart';
import 'package:unsplash_client_the_sequel/data/models/download_image_model.dart';
import 'dart:io';
import 'package:unsplash_client_the_sequel/domain/entities/download_image_entity.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/download_image_repository_interface.dart';

class DownloadImageRepositoryImpl extends IDownloadImageRepository {
  @override
  Future<DownloadImageEntity> downloadImage(String url) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
      if (!status.isGranted) {
        return DownloadImageMapper.map(DownloadImageModel("access denied"));
      }
    }

    String imageName =
        "unsplash_image_${DateTime.now().millisecondsSinceEpoch}.png";

    var response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    String downloadsDirectory =
        (await ExternalPath.getExternalStorageDirectories()).first;

    String path = downloadsDirectory + "/Unsplash/Photos/$imageName";
    File file = await File(path).create(recursive: true);
    if (await (await file.writeAsBytes(response.data!)).exists()) {
      return DownloadImageMapper.map(
          DownloadImageModel("image saved as $path"));
    } else {
      return DownloadImageMapper.map(
          DownloadImageModel("something went wrong"));
    }
  }
}
