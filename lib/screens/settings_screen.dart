import 'dart:convert';
import 'dart:io';
import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:clientmanager/src/providers/client_provider.dart';
import 'package:clientmanager/src/providers/event_provider.dart';
import 'package:clientmanager/src/providers/service_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'services_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<String> _generateBackupFile() async {
    final clientProvider = context.read<ClientProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    final eventProvider = context.read<EventProvider>();

    final allData = {
      'clients': clientProvider.clients.map((c) => c.toJson()).toList(),
      'services': serviceProvider.services.map((s) => s.toJson()).toList(),
      'events': eventProvider.events.map((e) => e.toJson()).toList(),
    };

    final jsonString = jsonEncode(allData);
    final tempDir = await getTemporaryDirectory();
    final fileName = 'clientmanager_backup_${DateTime.now().toIso8601String()}.json';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(jsonString);

    return file.path;
  }

  void _shareData() async {
    try {
      final filePath = await _generateBackupFile();
      await Share.shareXFiles([XFile(filePath)], text: 'ClientManager Backup');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.exportSuccess)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.exportError)));
      }
    }
  }

  void _saveData() async {
    try {
      final clientProvider = context.read<ClientProvider>();
      final serviceProvider = context.read<ServiceProvider>();
      final eventProvider = context.read<EventProvider>();

      final allData = {
        'clients': clientProvider.clients.map((c) => c.toJson()).toList(),
        'services': serviceProvider.services.map((s) => s.toJson()).toList(),
        'events': eventProvider.events.map((e) => e.toJson()).toList(),
      };

      final jsonString = jsonEncode(allData);
      final fileName = 'clientmanager_backup_${DateTime.now().toIso8601String()}.json';

      await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: fileName,
        bytes: utf8.encode(jsonString),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.exportSuccess)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.exportError)));
    }
  }

  void _importData() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        // Validazione del file
        if (data.containsKey('clients') && data.containsKey('services') && data.containsKey('events')) {
          // Mostra il dialogo di conferma
          final bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.warning),
              content: Text(l10n.overWriting),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
                TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.confirm)),
              ],
            ),
          );

          if (confirmed == true) {
            // Carica i dati
            context.read<ClientProvider>().clearAndLoad(data['clients']);
            context.read<ServiceProvider>().clearAndLoad(data['services']);
            context.read<EventProvider>().clearAndLoad(data['events']);
            
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.importSuccess)));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.invalidFileFormat)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.importError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(l10n.settingsName),
        centerTitle: true,
        titleTextStyle:
            Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.design_services, color: Theme.of(context).primaryColor),
              title: Text(l10n.servicesName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ServicesScreen())),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.upload_file, color: Theme.of(context).primaryColor),
                  title: Text(l10n.exportData),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: _shareData,
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_alt),
                        onPressed: _saveData,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.download, color: Theme.of(context).primaryColor),
                  title: Text(l10n.importData),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _importData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}