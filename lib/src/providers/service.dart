import 'package:flutter/foundation.dart';
import '../json_storage_provider.dart';

class PricePoint {
  final double price;
  final DateTime startDate;

  PricePoint({required this.price, required this.startDate});

  Map<String, dynamic> toJson() => {
        'price': price,
        'startDate': startDate.toIso8601String(),
      };

  factory PricePoint.fromJson(Map<String, dynamic> json) => PricePoint(
        price: (json['price'] as num).toDouble(),
        startDate: DateTime.parse(json['startDate']),
      );
}

class Service implements JsonSerializable {
  final String id;
  final String name;
  final List<PricePoint> priceHistory;
  final num time;

  Service({
    required this.id,
    required this.name,
    required this.priceHistory,
    required this.time,
  }) {
    // Assicura che la cronologia dei prezzi sia sempre ordinata
    priceHistory.sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  double get currentPrice {
    if (priceHistory.isEmpty) return 0.0;
    return priceHistory.first.price;
  }

  double getPriceForDate(DateTime date) {
    if (priceHistory.isEmpty) return 0.0;
    // La lista è già ordinata dalla più recente alla meno recente
    final pricePoint = priceHistory.firstWhere(
      (p) => date.isAfter(p.startDate) || date.isAtSameMomentAs(p.startDate),
      orElse: () => priceHistory.last, // Fallback al prezzo più vecchio se nessuna data corrisponde
    );
    return pricePoint.price;
  }

  void addPrice(double price, DateTime startDate) {
    priceHistory.add(PricePoint(price: price, startDate: startDate));
    priceHistory.sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'priceHistory': priceHistory.map((p) => p.toJson()).toList(),
        'time': time,
      };

  factory Service.fromJson(Map<String, dynamic> json) {
    var priceHistory = <PricePoint>[];
    if (json['priceHistory'] != null) {
      priceHistory = (json['priceHistory'] as List)
          .map((p) => PricePoint.fromJson(p))
          .toList();
    } else if (json.containsKey('price')) {
      // Compatibilità con il vecchio formato
      priceHistory.add(PricePoint(price: (json['price'] as num).toDouble(), startDate: DateTime(2000)));
    }

    return Service(
      id: json['id'],
      name: json['name'],
      priceHistory: priceHistory,
      time: json['time'],
    );
  }

  Service copyWith({String? name, num? time}) {
    return Service(
      id: id,
      name: name ?? this.name,
      priceHistory: List<PricePoint>.from(priceHistory),
      time: time ?? this.time,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}