import 'package:cloud_firestore/cloud_firestore.dart';

class ball {
  late String ball_id;
  late String sessionID;
  late String userID;
  late String uri;
  late String annotated_uri;
  late String prediction;
  late String recommendation;

  ball({
    required this.sessionID,
    required this.userID,
    required this.uri,
    required this.annotated_uri,
    required this.prediction,
    required this.recommendation,
  });

  Map<String, dynamic> toMap() {
    return {
      'ball_id': ball_id,
      'sessionID': sessionID,
      'userID': userID,
      'URI': uri,
      'annotated_uri': annotated_uri,
      'prediction': prediction,
      'recommendation': recommendation,
    };
  }

  factory ball.fromMap(Map<String, dynamic> map) {
    return ball(
      sessionID: map['sessionID'],
      userID: map['userID'],
      uri: map['URI'],
      annotated_uri: map['annotated_uri'],
      prediction: map['prediction'],
      recommendation: map['recommendation'],
    );
  }

  static fromJson(item) {
    return ball(
      sessionID: item['sessionID'],
      userID: item['userID'],
      uri: item['URI'],
      annotated_uri: item['annotated_uri'],
      prediction: item['prediction'],
      recommendation: item['recommendation'],
    );
  }
}
