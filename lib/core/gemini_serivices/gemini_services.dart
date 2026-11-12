import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:imageconvertor/core/gemini_serivices/api_key.dart';
import 'package:imageconvertor/core/gemini_serivices/client.dart';

class FalServices {
  final http.Client _client = http.Client();

  Future<Uint8List?> _postToNanoBanana({
    required String prompt,
    Uint8List? imageBytes,
  }) async {
     String? imageUrl;
    if (imageBytes != null) {
      imageUrl = await _uploadImage(imageBytes);
      if (imageUrl == null) return null;
    }

    final Map<String, dynamic> body = {
      "prompt": prompt,
      if (imageUrl != null) "image_urls": [imageUrl],
      "negative_prompt":
      "dull colors, washed out, flat, blurry, pixelated, low quality, "
          "oversaturated, cartoon, painting, deformed face, watermark, text, "
          "grainy, noisy, dark shadows, overexposed highlights",
      "guidance_scale": 8.0,
      "num_inference_steps": 35,
      "strength": 0.5,
    };

    try {
      final response = await _client.post(
            Uri.parse(ApiClient.imageEditEndpoint),
            headers: ApiClient.headers,
            body: jsonEncode(body),
          )
          .timeout(ApiClient.requestTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        String? imageUrlResult;

        if (json['images'] != null && (json['images'] as List).isNotEmpty) {
          imageUrlResult = json['images'][0]['url'] as String?;
        } else if (json['image'] != null && json['image']['url'] != null) {
          imageUrlResult = json['image']['url'] as String?;
        } else if (json['url'] != null) {
          imageUrlResult = json['url'] as String?;
        }

        if (imageUrlResult != null) {
          return await _downloadImage(imageUrlResult);
        }

      } else {

      }
    } catch (e) {
      print('_postToNanoBanana exception: $e');
    }
    return null;
  }

   Future<Uint8List?> _postToBirefnet(Uint8List imageBytes) async {
    final String? imageUrl = await _uploadImage(imageBytes);
    if (imageUrl == null) return null;

    final Map<String, dynamic> body = {
      "image_url": imageUrl,
      "model": "General Use (Light)",
    };

    try {
      final response = await _client
          .post(
            Uri.parse(ApiClient.bgRemovalEndpoint),
            headers: ApiClient.headers,
            body: jsonEncode(body),
          )
          .timeout(ApiClient.requestTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        String? imageUrlResult;

        if (json['images'] != null && (json['images'] as List).isNotEmpty) {
          imageUrlResult = json['images'][0]['url'] as String?;
        } else if (json['image'] != null && json['image']['url'] != null) {
          imageUrlResult = json['image']['url'] as String?;
        } else if (json['url'] != null) {
          imageUrlResult = json['url'] as String?;
        }

        if (imageUrlResult != null) {
          return await _downloadImage(imageUrlResult);
        }
        print('_postToBirefnet: No image. Body: ${response.body}');
      } else {
        developer.log('No image in response', name: 'FalService');

        print(
          '_postToBirefnet failed [${response.statusCode}]: ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('_postToBirefnet exception: $e');
      developer.log(
        "postToBirefnet exception",
        name:
            "this is a exception are occurred in the post to birefnet method",
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

   Future<String?> _uploadImage(Uint8List imageBytes) async {
    try {
       final initiateResponse = await _client
          .post(Uri.parse('https://rest.fal.ai/storage/upload/initiate?storage_type=fal-cdn-v3',),
        headers: {
          'Authorization': 'Key ${ApiKey.falKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'file_name': 'image.jpg',
          'content_type': 'image/jpeg',
        }),
      ).timeout(ApiClient.requestTimeout);

      developer.log(
        'Initiate response [${initiateResponse.statusCode}]: ${initiateResponse.body}',
        name: 'FalService',
      );

      if (initiateResponse.statusCode != 200) {
        developer.log(
          'Initiate failed: ${initiateResponse.statusCode}',
          name: 'FalService',
          error: initiateResponse.body,
        );
        return null;
      }

      final initiateJson = jsonDecode(initiateResponse.body);
      final String uploadUrl = initiateJson['upload_url'];
      final String fileUrl = initiateJson['file_url'];

       final uploadResponse = await _client.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: imageBytes,
      ).timeout(ApiClient.requestTimeout);

      developer.log(
        'PUT response [${uploadResponse.statusCode}]: ${uploadResponse.body}',
        name: 'FalService',
      );

      if (uploadResponse.statusCode == 200 || uploadResponse.statusCode == 204) {
        developer.log('Upload success: $fileUrl', name: 'FalService');
        return fileUrl; // ✅ CDN URL return
      }

      developer.log(
        'PUT upload failed: ${uploadResponse.statusCode}',
        name: 'FalService',
        error: uploadResponse.body,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Upload exception',
        name: 'FalService',
        error: e,
        stackTrace: stackTrace,
      );
      print('Upload exception: $e');
    }
    return null;
  }
   Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      print('Download exception: $e');
    }
    return null;
  }

   Future<Uint8List?> textToImage(
    String userPrompt, {
    Uint8List? imageBytes,
    String? ratio,
  }) async {
    String ratioText = ratio != null ? ' Aspect Ratio: $ratio.' : '';
    final String finalPrompt =
        '$userPrompt$ratioText '
        'The image must be sharp, well-lit, and visually rich with '
        'vibrant colors, fine details, and professional composition. '
        'Style: high-resolution digital photograph or premium digital art. '
        'No text, no watermarks, no borders.';

    return _postToNanoBanana(prompt: finalPrompt, imageBytes: imageBytes);
  }

   Future<Uint8List?> enhanceImage(Uint8List imageBytes) async {
    const    String enhancePrompt =
        'Enhance this photo with a vivid, punchy look similar to iPhone camera style. '
        'Boost color vibrancy and saturation naturally — make greens pop, skies look '
        'deep blue, and skin tones appear warm and healthy. '
        'Increase sharpness and clarity especially on facial features — eyes should '
        'look crisp and detailed, skin texture refined but natural, hair strands visible. '
        'Add subtle contrast boost to give depth and dimension to the image. '
        'Improve brightness in shadows without blowing out highlights — HDR-like balance. '
        'Remove all blur, noise, compression artifacts, and pixelation. '
        'The final result should look like it was shot on an iPhone 15 Pro with '
        'Photographic Styles set to Vibrant — vivid, sharp, colorful, and natural. '
        'Keep the exact same person, face, expression, and scene — only enhance, never alter.';

    return _postToNanoBanana(prompt: enhancePrompt, imageBytes: imageBytes);
  }

   Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    return _postToBirefnet(imageBytes); // birefnet use hoga
  }

   Future<Uint8List?> restoredOldPhoto(Uint8List imageBytes) async {
    const String prompt = '''
Carefully restore the provided old or damaged photograph.
Remove scratches, dust, cracks, stains, and visual noise.
Correct fading and color imbalance while preserving original tones.
Maintain authentic facial features, age lines, textures, and details.
Do not beautify, stylize, modernize, or modify the subject.
Do not add, remove, or replace any objects or background elements.
Preserve the original framing, proportions, and realism.
Return only the restored image with no additional text.
''';

    return _postToNanoBanana(prompt: prompt, imageBytes: imageBytes);
  }
}

 class FalResult<T> {
  final T? data;
  final String? error;
  bool get isSuccess => error == null && data != null;

  const FalResult.success(this.data) : error = null;
  const FalResult.failure(this.error) : data = null;
}

