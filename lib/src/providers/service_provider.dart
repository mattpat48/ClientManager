import 'service.dart';
import '../json_storage_provider.dart';

class ServiceProvider extends JsonStorageProvider<Service> {
  static const String _servicesKey = 'services_data';

  ServiceProvider()
      : super(
          storageKey: _servicesKey,
          fromJson: (json) => Service.fromJson(json),
        );

  List<Service> get services => items;

  void addService(Service service) {
    items.add(service);
    saveItems();
  }

  void removeService(String name) {
    items.removeWhere((service) => service.name == name);
    saveItems();
  }

  void clearAndLoad(List<dynamic> data) {
    items.clear();
    items.addAll(data.map((json) => fromJson(json)));
    saveItems();
  }
}