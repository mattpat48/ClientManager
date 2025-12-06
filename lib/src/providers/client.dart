import 'package:clientmanager/src/providers/event.dart';

import '../json_storage_provider.dart';

class Client implements JsonSerializable {
	final String id;
	String name;
	String? phoneNumber;
  List<String> appointments;

	Client({
		required this.id,
		required this.name,
		this.phoneNumber,
    this.appointments = const [],
	});

	factory Client.fromJson(Map<String, dynamic> json) {
		return Client(
			id: json['id'],
			name: json['name'],
			phoneNumber: json['phoneNumber'],
      appointments: List<String>.from(json['appointments'] ?? []),
		);
	}

	@override
	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'phoneNumber': phoneNumber,
      'appointments': appointments,
		};
	}
}