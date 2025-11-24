import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/client.dart';
import '../src/client_provider.dart';
import 'client_screen.dart';

class ClientsScreen extends StatefulWidget {
	const ClientsScreen({super.key});

	@override
	State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
	Future<void> _showAddClientDialog() async {
		final formKey = GlobalKey<FormState>();
		final nameController = TextEditingController();
		final phoneController = TextEditingController();

		return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text(AppLocalizations.of(context)!.newClientNamePlacheholder),
					content: Form(
						key: formKey,
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								TextFormField(
									controller: nameController,
									decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
									validator: (value) {
										if (value == null || value.isEmpty) {
											return AppLocalizations.of(context)!.pleaseInsertName;
										}
										return null;
									},
								),
								TextFormField(
									controller: phoneController,
									decoration: InputDecoration(labelText: AppLocalizations.of(context)!.phoneNumber),
									keyboardType: TextInputType.phone,
								),
							],
						),
					),
					actions: [
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								TextButton(
									child: Icon(Icons.close),
									onPressed: () => Navigator.of(context).pop(),
								),
								TextButton(
									child: Icon(Icons.check),
									onPressed: () => _addClient(context, formKey, nameController, phoneController),
								),
					])
					]
				);
			},
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Consumer<ClientProvider>(
				builder: (context, clientProvider, child) {
					if (clientProvider.clients.isEmpty) {
						return Center(
							child: Text(AppLocalizations.of(context)!.noClientsMessage),
						);
					}

					return ListView.builder(
						itemCount: clientProvider.clients.length,
						itemBuilder: (context, index) {
							final client = clientProvider.clients[index];
							return ListTile(
								leading: const CircleAvatar(child: Icon(Icons.person)),
								title: Text(client.name),
								subtitle: Text(client.phoneNumber ?? AppLocalizations.of(context)!.noPhoneNumberMessage),
								onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClientScreen(client: client,))),
							);
						},
					);
				},
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					_showAddClientDialog();
				},
				child: const Icon(Icons.add),
			),
		);
	}

	void _addClient(BuildContext context, GlobalKey<FormState> formKey, TextEditingController nameController, TextEditingController phoneController) {
		if (formKey.currentState!.validate()) {
			final newClient = Client(
				id: UniqueKey().toString(),
				name: nameController.text,
				phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : null,
			);
			context.read<ClientProvider>().addClient(newClient);
			Navigator.of(context).pop(); // Chiude il dialogo
		}
	}
}