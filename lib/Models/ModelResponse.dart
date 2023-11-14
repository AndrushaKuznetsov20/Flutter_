import 'dart:ffi';

import 'package:untitled5/Models/ModelAnnouncement.dart';
import 'package:untitled5/Models/ModelUser.dart';


class ModelResponse {
  final int id;
  final ModelAnnouncement announcement;
  final ModelUser user_response;

  ModelResponse({required this.id, required this.announcement, required this.user_response});

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    return ModelResponse(
      id: json['id'],
      announcement: ModelAnnouncement.fromJson(json['announcement']),
      user_response: ModelUser.fromJson(json['user_response']),
    );
  }
}