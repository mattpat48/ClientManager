import '../json_storage_provider.dart';

class Service implements JsonSerializable {
  final String name;
  final double price;
  final double time;

  Service({
    required this.name,
    required this.price,
    required this.time,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      price: json['price'],
      time: json['time'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'time': time,
    };
  }
}