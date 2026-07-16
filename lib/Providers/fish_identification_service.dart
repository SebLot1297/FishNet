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
  final String? scientificName;

  FishIdentificationOutcome({required this.result,this.speciesName,
  this.errorDetail, this.scientificName
  });
}

String sanitizeSpeciesName(String raw) {
  var cleaned = raw.trim();
  cleaned = cleaned.replaceAll(RegExp(r'[.\n]+$'), ''); // trailing punctuation/newlines
  return cleaned;
}

String stripCodeFences(String text) {
  var cleaned = text.trim();
  if (cleaned.startsWith('```')) {
    cleaned = cleaned.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'\n?```$'), '');
  }
  return cleaned.trim();
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
  'max_tokens': 100,
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
          'text': 'You are a fish identification expert analyzing a photo taken by an angler. Look at the image and identify the fish species shown. Respond with ONLY a raw JSON object — no markdown formatting, no code fences, no explanatory text before or after. If a fish is clearly visible and identifiable, respond in this exact example shape: { "commonName": "Largemouth Bass", "scientificName": "Micropterus salmoides" } Rules for scientificName: Always provide genus AND species (two words), never just the genus. Use the currently accepted name, not an outdated synonym, to the best of your knowledge. Capitalize only the genus (first word); species stays lowercase. If you are only confident enough to narrow it down to genus level, still provide your best full species-level guess rather than leaving it incomplete. If no fish is clearly visible in the image, or the image is too unclear/blurry/dark to identify anything, respond with exactly this shape instead: { "commonName": "NO_FISH_DETECTED", "scientificName": "NO_FISH_DETECTED" } Do not include any fields other than commonName and scientificName. Do not include confidence levels, descriptions, or any other text.',
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
  final rawText = stripCodeFences(json['content'][0]['text']);

  Map<String, dynamic> parsed;
  try {
    parsed = jsonDecode(rawText);
  } catch (e) {
    return FishIdentificationOutcome(
      result: IdentificationResult.failed,
      errorDetail: 'Claude returned malformed JSON: $rawText',
    );
  }

  final commonName = sanitizeSpeciesName(parsed['commonName']);
  final scienceName = sanitizeSpeciesName(parsed['scientificName']);
  if(commonName == "NO_FISH_DETECTED"){
      return FishIdentificationOutcome(result: IdentificationResult.failed, 
errorDetail: "The API was not able to identify a fish");
  }
  return FishIdentificationOutcome(result: IdentificationResult.success,
   speciesName: commonName, scientificName: scienceName);
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