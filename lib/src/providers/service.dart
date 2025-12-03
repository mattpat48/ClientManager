import '../json_storage_provider.dart';

class Service implements JsonSerializable {
  final String name;
  final double price;

  Service({
    required this.name,
    required this.price
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      price: json['price'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}