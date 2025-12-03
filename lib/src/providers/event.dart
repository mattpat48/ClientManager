import 'service.dart';
import '../json_storage_provider.dart';

class Event implements JsonSerializable {
  final String id;
  final String userId;
  final DateTime date;
  final List<Service> services;

  Event({
    required this.id,
    required this.userId,
    required this.date,
    required this.services,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    List<Service> services =
        servicesList.map((i) => Service.fromJson(i)).toList();

    return Event(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      services: services,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'services': services.map((service) => service.toJson()).toList(),
    };
  }

  @override
  String toString() => id;

}