import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> sendVideoToServer(String videoFile) async {
  var file = File(videoFile);
  if (!file.existsSync()) {
    print('File does not exist at path: $videoFile');
    return;
  }
  print(videoFile);
  var request =
      http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/uploads'));
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    print('Video uploaded successfully');
  } else {
    print('Failed to upload video. Error: ${response.reasonPhrase}');
  }
}
