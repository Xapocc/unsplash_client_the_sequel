import 'package:get_it/get_it.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/download_image_repository_interface.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/images_page_repository_interface.dart';
import 'package:unsplash_client_the_sequel/domain/use_cases/Images_page_use_case.dart';
import 'package:unsplash_client_the_sequel/domain/use_cases/download_image_use_case.dart';

class DomainDependencyInjection {
  DomainDependencyInjection(GetIt getIt) {
    getIt.registerSingletonWithDependencies<ImagesPageUseCase>(
      () => ImagesPageUseCase(getIt.get<IImagesPageRepository>()),
      dependsOn: [IImagesPageRepository],
    );
    getIt.registerSingletonWithDependencies<DownloadImageUseCase>(
      () => DownloadImageUseCase(getIt.get<IDownloadImageRepository>()),
      dependsOn: [IDownloadImageRepository],
    );
  }
}
