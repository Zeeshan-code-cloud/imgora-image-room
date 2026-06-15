import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:imageconvertor/core/admob_services/rewarded_services.dart';
import 'package:imageconvertor/core/routes_config/app_pages.dart';
import 'package:imageconvertor/core/routes_config/app_routes.dart';
import 'package:imageconvertor/features/recen_activities/recent_activities_binding.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  ///for edge to edge status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  bool isFirebaseInitialized = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    isFirebaseInitialized = true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  if (isFirebaseInitialized) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  try {
    await AdManager().initialize();
  } catch (e) {
    debugPrint('AdManager initialization failed: $e');
  }

  runApp(const ImageConverterApp());
}

class ImageConverterApp extends StatelessWidget {
  const ImageConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return  GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Image Converter',
          getPages: AppPages.routes,
          initialRoute: AppRoutes.splashView,
          initialBinding: RecentActivitiesBinding(),
          theme: ThemeData(
            fontFamily: 'Inter',
            scaffoldBackgroundColor: Colors.white,
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
