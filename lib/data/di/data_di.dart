import 'package:get_it/get_it.dart';
import 'package:unsplash_client_the_sequel/data/repository_implementations/download_image_repository_impl.dart';
import 'package:unsplash_client_the_sequel/data/repository_implementations/images_page_http_repository_impl.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/download_image_repository_interface.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/images_page_repository_interface.dart';

class DataDependencyInjection {
  DataDependencyInjection(GetIt getIt) {
    getIt.registerSingleton<IImagesPageRepository>(
        ImagesPageHttpRepositoryImpl());
    getIt.registerSingleton<IDownloadImageRepository>(
        DownloadImageRepositoryImpl());
  }
}
