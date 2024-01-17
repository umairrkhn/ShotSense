import 'package:cloud_firestore/cloud_firestore.dart';
import 'ball.dart';
class session{
  late String name;
  late String userID;
  late Timestamp createdAt;
  late bool completed = false;
  List<ball> balls = [];

  session({
    required this.name,
    required this.userID,
    required this.createdAt,
    required this.completed,
    required this.balls,
  });

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'userID': userID,
      'createdAt': createdAt,
      'completed': completed,
      'balls': balls.map((e) => e.toMap()).toList(),
    };
  }

  factory session.fromMap(Map<String, dynamic> map){
    return session(
      name: map['name'],
      userID: map['userID'],
      createdAt: map['createdAt'],
      completed: map['completed'],
      balls: map['balls'],
    );
  }
}