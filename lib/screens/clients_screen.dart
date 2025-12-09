import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../src/providers/client.dart';
import '../src/providers/client_provider.dart';
import 'form_field_data.dart';
import 'listable_screen.dart';
import 'client_screen.dart';

class ClientsScreen extends StatefulWidget {
	const ClientsScreen({super.key});

	@override
	State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  Future<void> _showRemoveClientDialog(Client client) async {
		return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
				return AlertDialog(
					title: Text(client.name),
					content: Text(AppLocalizations.of(context)!.removeCustomerConfirmation),
					actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.confirm),
              onPressed: () {
                context.read<ClientProvider>().removeClient(client.id);
                Navigator.of(context).pop();
              },
            ),
					],
				);
			},
		);
	}

	@override
	Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

		return ListableScreenWithForm<ClientProvider, Client>(
      appBarTitle: AppLocalizations.of(context)!.customersName,
      dialogTitle: l10n.newCustomerNamePlacheholder,
      noItemsMessage: AppLocalizations.of(context)!.noCustomersMessage,
      getItems: (provider) => provider.clients,
      formFields: [
        FormFieldData(
          label: l10n.name,
          validator: (value) => (value == null || value.isEmpty) ? l10n.pleaseInsertName : null,
        ),
        FormFieldData(
          label: l10n.phoneNumber,
          keyboardType: TextInputType.phone,
        ),
      ],
      createItemFromForm: (formResults) {
        return Client(
          id: UniqueKey().toString(),
          name: formResults[l10n.name]!,
          phoneNumber: formResults[l10n.phoneNumber],
        );
      },
      addItemToProvider: (provider, item) => provider.addClient(item),
      itemBuilder: (ctx, client) {
        final hasPhoneNumber = client.phoneNumber != null && client.phoneNumber!.isNotEmpty;
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(client.name),
          subtitle: Text(client.phoneNumber ?? l10n.noPhoneNumberMessage),
          trailing: hasPhoneNumber
              ? IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: client.phoneNumber,
                    );
                    await launchUrl(launchUri);
                  },
                )
              : null,
          onTap: () => Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (innerContext) => ClientScreen(client: client),
            ),
          ),
          onLongPress: () => _showRemoveClientDialog(client),
        );
      },
    );
	}
}