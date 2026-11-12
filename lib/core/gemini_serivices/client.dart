import 'package:imageconvertor/core/gemini_serivices/api_key.dart';


class ApiClient {
  // static const String baseUrl =
  //     'https://generativelanguage.googleapis.com/v1beta/models';
  //
  // static const String imagenModel    = 'gemini-3.1-flash-image';
  //
  //
  //
  //  static String get imageEndpoint =>
  //     '$baseUrl/$imagenModel:generateContent?key=${ApiKey.geminiKey}';
  //
  // static const Duration requestTimeout = Duration(seconds: 320);
   // static const double defaultTemperature = 1.0;


  static const String baseUrl = 'https://fal.run';
  static const String nanoBananaModel = 'openai/gpt-image-2.5/sunburst/edit';
  static const String bgRemovalModel = 'fal-ai/birefnet';

  static String get imageEditEndpoint => '$baseUrl/$nanoBananaModel';
  static String get bgRemovalEndpoint => '$baseUrl/$bgRemovalModel';

  static const Duration requestTimeout = Duration(seconds: 180);

  static Map<String, String> get headers => {
    'Authorization': 'Key ${ApiKey.falKey}',
    'Content-Type': 'application/json',
  };

}