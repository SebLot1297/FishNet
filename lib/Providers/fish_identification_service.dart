import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum IdentificationResult {
  success,
  noConnectivity,
  retryableError,
  failed,
}

class FishIdentificationOutcome {
  final IdentificationResult result;
  final String? speciesName;
  final String? errorDetail;

  FishIdentificationOutcome({required this.result,this.speciesName,
  this.errorDetail,
  });
}

String sanitizeSpeciesName(String raw) {
  var cleaned = raw.trim();
  cleaned = cleaned.replaceAll(RegExp(r'[.\n]+$'), ''); // trailing punctuation/newlines
  return cleaned;
}

class FishIdentificationService{
  
Future<FishIdentificationOutcome> identifyFish(String imagePath) async {
try{

  final compressedBytes = await FlutterImageCompress.compressWithFile(
  imagePath,
  minWidth: 800,
  minHeight: 600,
  quality: 85,
);

  if (compressedBytes == null) {
        return FishIdentificationOutcome(
          result: IdentificationResult.failed,
          errorDetail: 'Image compression returned null',
        );
      }

   final base64Image = base64Encode(compressedBytes);

  final body = jsonEncode({
  'model': 'claude-haiku-4-5-20251001',
  'max_tokens': 50,
  'messages': [
    {
      'role': 'user',
      'content': [
        {
          'type': 'image',
          'source': {
            'type': 'base64',
            'media_type': 'image/jpeg',
            'data': base64Image,
          },
        },
        {
          'type': 'text',
          'text': 'Identify the fish species in this image. Respond with ONLY the common name, in title case, with no punctuation, no extra words, and no explanation. Example correct response: Largemouth Bass',
        },
      ],
    }
  ],
});

final response = await(http.post(
  Uri.parse('https://api.anthropic.com/v1/messages'),
  headers: {
    'x-api-key': dotenv.env['ANTHROPIC_API_KEY'] ?? '',
    'anthropic-version': '2023-06-01',
    'content-type': 'application/json',
  },
  body: body,
));


      // - 200 → try to parse content, return success
      // - 429 or 500-599 → return retryableError
      // - anything else (401, 400, etc.) → return failed, with errorDetail set from the body
if(response.statusCode == 200){
  final json = jsonDecode(response.body);
  final species = sanitizeSpeciesName(json['content'][0]['text']);
  return FishIdentificationOutcome(result: IdentificationResult.success,
   speciesName: species);
}

else if(response.statusCode == 429 || (response.statusCode >= 500 && response.statusCode <=599)){
  return FishIdentificationOutcome(result: IdentificationResult.retryableError,
  errorDetail: 'An error occured, the fish will be rerecognized automatically in the background!');
}
return FishIdentificationOutcome(result: IdentificationResult.failed, 
errorDetail: response.body);
}

on SocketException catch (e) {
  // no connection to internet
  return FishIdentificationOutcome(
        result: IdentificationResult.noConnectivity,
        errorDetail: e.toString(),
      );

}

catch(e){
  return FishIdentificationOutcome(
        result: IdentificationResult.failed,
        errorDetail: e.toString(),
      );
}
}
}