import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class FishIdentificationService{
Future<String?> identifyFish(String imagePath) async {
try{

  final compressedBytes = await FlutterImageCompress.compressWithFile(
  imagePath,
  minWidth: 800,
  minHeight: 600,
  quality: 85,
);

  if (compressedBytes == null) return null;
  final base64Image = base64Encode(compressedBytes);


  final body = jsonEncode({
  'model': 'claude-sonnet-4-6',
  'max_tokens': 1024,
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
          'text': 'What species of fish is in this image? Reply with only the species common name, do not include the scientific name.',
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
final json = jsonDecode(response.body);
return json['content'][0]['text'];
}

catch(e){
  return null;
}
}
}