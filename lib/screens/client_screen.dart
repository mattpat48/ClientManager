import 'package:flutter/material.dart';
import '../src/client.dart';

class ClientScreen extends StatefulWidget {
	final Client client;

	const ClientScreen({super.key, required this.client});

	@override
	State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.client.name),
			)
		);
	}
}