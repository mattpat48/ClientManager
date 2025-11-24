import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../src/client.dart';

class ClientProvider with ChangeNotifier {
	List<Client> _clients = [];
	static const String _clientsKey = 'clients_data';

	ClientProvider() {
		_loadClients();
	}

	Future<void> _saveClients() async {
		final prefs = await SharedPreferences.getInstance();
		final String encodedData = jsonEncode(
			_clients.map((client) => client.toJson()).toList(),
		);
		await prefs.setString(_clientsKey, encodedData);
	}

	Future<void> _loadClients() async {
		final prefs = await SharedPreferences.getInstance();
		final String? clientsString = prefs.getString(_clientsKey);

		if (clientsString != null) {
			final List<dynamic> decodedData = jsonDecode(clientsString);
			_clients = decodedData.map((json) => Client.fromJson(json)).toList();
			notifyListeners();
		}
	}


    List<Client> get clients => _clients;

    void addClient(Client client) {
        _clients.add(client);
		_saveClients();
        notifyListeners();
    }
}