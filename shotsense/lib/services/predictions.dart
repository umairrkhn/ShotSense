import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> sendFileToServer(File file) async {
  var url = Uri.parse('http://10.0.2.2:8000/predict');

  print('File path: ${file.path}');
  print(file);
  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('file', file.path));

  var response = await request.send();
  var responseBody = await response.stream.bytesToString();
  print(jsonDecode(responseBody));
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Error uploading file. Status code: ${response.statusCode}');
  }
  //add prediction to correct over in firebase

  return jsonDecode(responseBody)['prediction'];
}
