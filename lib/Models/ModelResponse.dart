import 'dart:ffi';

import 'package:untitled5/Models/ModelAnnouncement.dart';

import 'ModelUser.dart';

class ModelResponse {
  final int id;
  final ModelAnnouncement announcement;
  final ModelUser user_response;

  ModelResponse({required this.id, required this.announcement, required this.user_response});

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    return ModelResponse(
      id: json['id'],
      announcement: json['announcement'],
      user_response: json['user_response'],
    );
  }
}