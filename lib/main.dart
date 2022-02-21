import 'package:flutter/cupertino.dart';
import 'package:unsplash_client_the_sequel/app/app_root.dart';
import 'package:unsplash_client_the_sequel/data/repository_implementations/images_page_http_repository_impl.dart';
import 'package:unsplash_client_the_sequel/domain/use_cases/Images_page_use_case.dart';

ImagesPageUseCase imagesPageUseCase = ImagesPageUseCase(ImagesPageHttpRepositoryImpl());

void main() {
  runApp(const AppRoot());
}