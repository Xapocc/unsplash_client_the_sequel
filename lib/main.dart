import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:unsplash_client_the_sequel/app/app_root.dart';
import 'package:unsplash_client_the_sequel/data/repository_implementations/images_page_http_repository_impl.dart';
import 'package:unsplash_client_the_sequel/domain/use_cases/Images_page_use_case.dart';

void main() {

  GetIt.I.registerSingleton<ImagesPageUseCase>(ImagesPageUseCase(ImagesPageHttpRepositoryImpl()));

  runApp(AppRoot());
}