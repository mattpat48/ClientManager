import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
	MaterialApp(
		localizationsDelegates: AppLocalizations.localizationsDelegates,
		supportedLocales: AppLocalizations.supportedLocales,
		home: MainApp(),
	));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
	final _key = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context) {
      	return MaterialApp(
			localizationsDelegates: AppLocalizations.localizationsDelegates,
        	supportedLocales: AppLocalizations.supportedLocales,
			home: Scaffold(
				key: _key,
          		appBar: AppBar(
            		title: Text(AppLocalizations.of(context)!.helloWorld),
          		),
          		body: const Center(),
        	),
      	);
    }
}