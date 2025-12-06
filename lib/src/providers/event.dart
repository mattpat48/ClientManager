import 'package:flutter/material.dart';

import 'service.dart';
import '../json_storage_provider.dart';

class Event implements JsonSerializable {
  final String id;
  final String customerId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<Service> services;

  Event({
    required this.id,
    required this.customerId,
    required this.date,
    required this.services,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    List<Service> services =
        servicesList.map((i) => Service.fromJson(i)).toList();

    return Event(
      id: json['id'],
      customerId: json['customerId'],
      date: DateTime.parse(json['date']),
      services: services,
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(json['endTime'])),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'customerId': customerId,
      'date': date.toIso8601String(),
      'startTime': DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute).toIso8601String(),
      'endTime': DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute).toIso8601String(),
      'services': services.map((s) => s.toJson()).toList(),
    };
  }

  @override
  String toString() => id;

  Event copyWith({List<Service>? services}) {
    return Event(
        id: id, customerId: customerId, date: date, services: services ?? this.services, startTime: startTime, endTime: endTime);
  }

}