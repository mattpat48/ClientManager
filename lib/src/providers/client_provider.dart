import 'client.dart';
import '../json_storage_provider.dart';

class ClientProvider extends JsonStorageProvider<Client> {
  static const String _clientsKey = 'clients_data';

  ClientProvider()
      : super(
          storageKey: _clientsKey,
          fromJson: (json) => Client.fromJson(json),
        );

  List<Client> get clients => items;

  void addClient(Client client) {
    items.add(client);
    saveItems();
  }

  void removeClient(String id) {
    items.removeWhere((client) => client.id == id);
    saveItems();
  }

  void updateClient(Client client) {
    // Non è necessario fare nulla qui se l'oggetto client è già stato modificato in memoria
    saveItems();
  }

  void clearAndLoad(List<dynamic> data) {
    items.clear();
    items.addAll(data.map((json) => fromJson(json)));
    saveItems();
  }
}