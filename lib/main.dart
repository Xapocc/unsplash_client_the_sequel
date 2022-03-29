import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:unsplash_client_the_sequel/app/app_root.dart';
import 'package:unsplash_client_the_sequel/data/di/data_di.dart';
import 'package:unsplash_client_the_sequel/domain/di/domain_di.dart';

void main() {
  DataDependencyInjection(GetIt.I);
  DomainDependencyInjection(GetIt.I);

  runApp(AppRoot());
}
