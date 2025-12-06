import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:clientmanager/src/providers/service.dart';
import 'package:clientmanager/src/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_field_data.dart';
import 'listable_screen.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  Future<void> _showRemoveServiceDialog(Service service) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(service.name),
          content: Text(AppLocalizations.of(context)!.removeServiceConfirmation),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Icon(Icons.check),
                  onPressed: () {
                    context.read<ServiceProvider>().removeService(service.name);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListableScreenWithForm<ServiceProvider, Service>(
      appBarTitle: l10n.servicesName,
      dialogTitle: l10n.newServiceNamePlaceholder,
      noItemsMessage: l10n.noServicesMessage,
      getItems: (provider) => provider.services,
      formFields: [
        FormFieldData(
          label: l10n.name,
          validator: (value) => (value == null || value.isEmpty) ? l10n.pleaseInsertName : null,
        ),
        FormFieldData(
          label: l10n.price,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => (value == null || value.isEmpty || double.tryParse(value) == null) ? l10n.pleaseInsertPrice : null,
        ),
        FormFieldData(
          label: l10n.time,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        )
      ],
      createItemFromForm: (formResults) {
        return Service(
          name: formResults[l10n.name]!,
          price: double.parse(formResults[l10n.price]!),
          time: double.parse(formResults[l10n.time]!),
        );
      },
      addItemToProvider: (provider, item) => provider.addService(item),
      itemBuilder: (ctx, service) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.miscellaneous_services)),
          title: Text(service.name),
          subtitle: Text('${service.price.toStringAsFixed(2)} €'),
          onTap: () => Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (innerContext) => ServiceDetailsScreen(service: service),
            ),
          ),
          onLongPress: () => _showRemoveServiceDialog(service),
        );
      },
    );
  }
}