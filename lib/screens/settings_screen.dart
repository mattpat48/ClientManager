import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'services_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.design_services),
                title: Text(AppLocalizations.of(context)!.servicesName),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ServicesScreen()));
                },
              ),
            ),
          ]
        ),
      )
    );
  }
}