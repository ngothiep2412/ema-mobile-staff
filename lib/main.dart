import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
         localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('vi', 'VN'), // Set the Locale to Vietnamese
      ],
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
