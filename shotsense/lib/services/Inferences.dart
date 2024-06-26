import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> getInference(
    File file, String sessionID, String over, String ball) async {
  var url =
      Uri.parse('https://inference-function-uoglzgacta-uc.a.run.app/inference');

  print('File path: ${file.path}');
  print(file);
  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();
  print('Response body: $responseBody');
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Error uploading file. Status code: ${response.statusCode}');
  }

  getAnnotation(file, sessionID, over, ball);

  return responseBody;
}

Future<String> getAnnotation(
    File file, String sessionID, String over, String ball) async {
  var url = Uri.parse(
      'https://supervision-backend-uoglzgacta-uc.a.run.app/annotate_video');

  print('File path: ${file.path}');
  print(file);
  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', file.path));
  request.fields['sessionID'] = sessionID;
  request.fields['over'] = over;
  request.fields['ball'] = ball;

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();
  print('Response body: $responseBody');
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Error uploading file. Status code: ${response.statusCode}');
  }
  //add prediction to correct over in firebase

  return responseBody;
}
