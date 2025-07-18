import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';
import 'package:gram_sanjog/controller/news_controller.dart';
import 'package:gram_sanjog/view/bookmark_view.dart';
import 'package:gram_sanjog/view/home_page_view.dart';
import 'package:gram_sanjog/view/page_layout.dart';
import 'bindings/home_bindings.dart';
import 'common/theme/theme.dart';
import 'controller/auth/user_controller.dart';
import 'controller/bookmark_controller.dart';
import 'controller/top_news_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  Get.put(BookmarkController());
  Get.put(TopNewsController());
  Get.lazyPut(() => NewsController());
  Get.put(SearchController());
  Get.put(AuthController());
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      title: 'Gram Sanjog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.highlight),
        useMaterial3: true,
      ),
      home: MainPage(),
      //initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: HomeBindings(),
        ),
      ],
    );
  }
}