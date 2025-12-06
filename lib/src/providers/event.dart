import 'package:flutter/material.dart';

import 'service.dart';
import '../json_storage_provider.dart';

class Event implements JsonSerializable {
  final String id;
  String customerId;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<Service> services;
  String? note;

  Event({
    required this.id,
    required this.customerId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.services,
    this.note,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    var servicesList = json['services'] as List;
    List<Service> services =
        servicesList.map((i) => Service.fromJson(i)).toList();

    return Event(
      id: json['id'],
      customerId: json['customerId'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(json['endTime'])),
      services: services,
      note: json['note'],
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
      'note': note,
    };
  }

  @override
  String toString() => id;

  Event copyWith({List<Service>? services}) {
    return Event(
        id: id, customerId: customerId, date: date, services: services ?? this.services, startTime: startTime, endTime: endTime, note: note);
  }

}