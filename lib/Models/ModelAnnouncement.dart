import 'dart:ffi';

class ModelAnnouncement {
  final int id;
  final String name;
  final String description;
  final String conditions_and_requirements;

  ModelAnnouncement({required this.id,required this.name, required this.description, required this.conditions_and_requirements});

  factory ModelAnnouncement.fromJson(Map<String, dynamic> json) {
    return ModelAnnouncement(
        id: json['id'],
      name: json['name'],
      description: json['description'],
      conditions_and_requirements: json['conditions_and_requirements']
    );
  }
}