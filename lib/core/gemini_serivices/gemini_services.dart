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
    // Image upload karo agar hai
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
      final response = await _client
          .post(
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
        print(
          '_postToNanoBanana: No image in response. Body: ${response.body}',
        );
      } else {
        print(
          '_postToNanoBanana failed [${response.statusCode}]: ${response.body}',
        );
      }
    } catch (e) {
      print('_postToNanoBanana exception: $e');
    }
    return null;
  }

  // ── CORE: POST TO BIREFNET (BG REMOVAL) ──────────────────────────────────
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

  // ── HELPER: IMAGE UPLOAD (fal.ai storage) ────────────────────────────────
  Future<String?> _uploadImage(Uint8List imageBytes) async {
    try {
      // ── STEP 1: Initiate upload ──────────────────────────────
      final initiateResponse = await _client
          .post(
        Uri.parse(
          'https://rest.fal.ai/storage/upload/initiate?storage_type=fal-cdn-v3',
        ),
        headers: {
          'Authorization': 'Key ${ApiKey.falKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'file_name': 'image.jpg',
          'content_type': 'image/jpeg',
        }),
      )
          .timeout(ApiClient.requestTimeout);

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

      // ── STEP 2: Upload bytes to presigned URL ────────────────
      final uploadResponse = await _client
          .put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: imageBytes,
      )
          .timeout(ApiClient.requestTimeout);

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
  // ── HELPER: DOWNLOAD IMAGE FROM URL ──────────────────────────────────────
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      print('Download exception: $e');
    }
    return null;
  }

  // ── PUBLIC: TEXT TO IMAGE ─────────────────────────────────────────────────
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

  // ── PUBLIC: ENHANCE IMAGE ─────────────────────────────────────────────────
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

  // ── PUBLIC: REMOVE BACKGROUND ─────────────────────────────────────────────
  Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    return _postToBirefnet(imageBytes); // birefnet use hoga
  }

  // ── PUBLIC: RESTORE OLD PHOTO ─────────────────────────────────────────────
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

// ── RESULT WRAPPER (same rakha) ───────────────────────────────────────────
class FalResult<T> {
  final T? data;
  final String? error;
  bool get isSuccess => error == null && data != null;

  const FalResult.success(this.data) : error = null;
  const FalResult.failure(this.error) : data = null;
}

// class GeminiServices {
//   final http.Client _client = http.Client();
//
//    Future<Uint8List?> _postToGemini(List<Map<String, dynamic>> parts) async {
//     final body = {
//       "contents": [
//         {"parts": parts}
//       ],
//       "generationConfig": {
//         "responseModalities": ["image", "text"],
//       }
//     };
//
//     try {
//       final response = await _client
//           .post(
//         Uri.parse(ApiClient.imageEndpoint),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       ).timeout(ApiClient.requestTimeout);
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         final parts =
//         json['candidates']?[0]?['content']?['parts'] as List?;
//         if (parts != null) {
//           for (final part in parts) {
//             final inlineData = part['inlineData'];
//             if (inlineData != null && inlineData['data'] != null) {
//               return base64Decode(inlineData['data'] as String);
//             }
//           }
//         }
//         print('_postToGemini: No image in response. Body: ${response.body}');
//       } else {
//         print('_postToGemini failed [${response.statusCode}]: ${response.body}');
//       }
//     } catch (e) {
//       print('_postToGemini exception: $e');
//     }
//     return null;
//   }
//
//
//
//     Future<Uint8List?> textToImage(
//       String userPrompt, {
//         Uint8List? imageBytes,
//         String? ratio,
//       }) async {
//     // Build prompt
//     String ratioText = ratio != null ? ' Aspect Ratio: $ratio.' : '';
//     final String finalPrompt =
//         '$userPrompt$ratioText '
//          'The image must be sharp, well-lit, and visually rich with '
//         'vibrant colors, fine details, and professional composition. '
//         'Style: high-resolution digital photograph or premium digital art. '
//         'No text, no watermarks, no borders.';
//
//     // Build parts — add image if editing
//     final List<Map<String, dynamic>> parts = [
//       {"text": finalPrompt}
//     ];
//
//     if (imageBytes != null) {
//       parts.add({
//         "inlineData": {
//           "mimeType": "image/jpeg",
//           "data": base64Encode(imageBytes),
//         }
//       });
//     }
//
//     return _postToGemini(parts);
//   }
//
//   // ── PUBLIC: ENHANCE IMAGE ────────────────────────────────────────────────
//   Future<Uint8List?> enhanceImage(Uint8List imageBytes) async {
//     const String prompt =
//         'You are an advanced image restoration and super-resolution model. '
//         'This image was captured using an old low-quality phone camera and contains '
//         'heavy blur, pixelation, motion artifacts, and compression damage. '
//         'Actively reconstruct the image by performing the following:\n\n'
//         '• Super-resolution upscaling to modern HD quality\n'
//         '• Rebuild lost facial details: eyes, lips, nose, skin texture\n'
//         '• Remove pixelation, blur, color bleeding, and compression artifacts\n'
//         '• Correct distorted edges, noise, and motion artifacts\n'
//         '• Improve overall clarity to match a modern smartphone camera\n\n'
//         'STRICT RULES:\n'
//         '- Preserve the original persons identity, facial proportions, '
//         'expression, and color tones exactly\n'
//         '- Do NOT beautify, stylize, cartoonize, or artistically modify\n'
//         '- Do NOT change makeup style, facial structure, or lighting intent\n'
//         '- Do NOT add or remove any elements, objects, or people\n'
//         '- Do NOT add text, logos, watermarks, or borders\n'
//         '- The result must look like the same photo captured clearly '
//         'with a modern smartphone camera\n'
//         'Output only the enhanced image.';
//
//     final List<Map<String, dynamic>> parts = [
//       {"text": prompt},
//       {
//         "inlineData": {
//           "mimeType": "image/jpeg",
//           "data": base64Encode(imageBytes),
//         }
//       }
//     ];
//
//     return _postToGemini(parts);
//   }
//
//
//   // ── PUBLIC: REMOVE BACKGROUND ─────────────────────────────────────────────
//   Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
//     const String prompt = '''
// Precisely remove the entire background from the image.
// Isolate the primary subject (person, animal, or object) only.
// Preserve all fine details including hair, fur, whiskers, and sharp edges.
// Do not add, replace, blur, recolor, resize, or modify any part of the subject.
// Do not crop the image.
// Return the final result with a transparent background in PNG format.
// Output only the final image with no additional text.
// ''';
//
//     final List<Map<String, dynamic>> parts = [
//       {"text": prompt},
//       {
//         "inlineData": {
//            "mimeType": "image/png",
//           "data": base64Encode(imageBytes),
//         }
//       }
//     ];
//
//     return _postToGemini(parts);
//   }
//
//
//   Future<Uint8List?> restoredOldPhoto(Uint8List imageBytes) async {
//     const String prompt = '''
// Carefully restore the provided old or damaged photograph.
// Remove scratches, dust, cracks, stains, and visual noise.
// Correct fading and color imbalance while preserving original tones.
// Maintain authentic facial features, age lines, textures, and details.
// Do not beautify, stylize, modernize, or modify the subject.
// Do not add, remove, or replace any objects or background elements.
// Preserve the original framing, proportions, and realism.
// Return only the restored image with no additional text.
// ''';
//
//     final List<Map<String, dynamic>> parts = [
//       {"text": prompt},
//       {
//         "inlineData": {
//           "mimeType": "image/png",
//           "data": base64Encode(imageBytes),
//         }
//       }
//     ];
//
//     return _postToGemini(parts);
//   }
//
//
//
// }
//
//
// class GeminiResult<T> {
//   final T? data;
//   final String? error;
//   bool get isSuccess => error == null && data != null;
//
//   const GeminiResult.success(this.data) : error = null;
//   const GeminiResult.failure(this.error) : data = null;
// }
