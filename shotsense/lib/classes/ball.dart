import 'package:cloud_firestore/cloud_firestore.dart';

class ball {
  late String sessionID;
  late String userID;
  late String URI;
  late String prediction;

  ball({
    required this.sessionID,
    required this.userID,
    required this.URI,
    required this.prediction,
  });

  Map<String, dynamic> toMap(){
    return{
      'sessionID': sessionID,
      'userID': userID,
      'URI': URI,
      'prediction': prediction,
    };
  }

  factory ball.fromMap(Map<String, dynamic> map){
    return ball(
      sessionID: map['sessionID'],
      userID: map['userID'],
      URI: map['URI'],
      prediction: map['prediction'],
    );
  }
}