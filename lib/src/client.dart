import 'package:flutter/foundation.dart';

class Client {
	final String id;
	final String name;
	final String? phoneNumber;

	Client({
		required this.id,
		required this.name,
		this.phoneNumber,
	});

	factory Client.fromJson(Map<String, dynamic> json) {
		return Client(
			id: json['id'],
			name: json['name'],
			phoneNumber: json['phoneNumber'],
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'phoneNumber': phoneNumber,
		};
	}
}