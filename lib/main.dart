import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'home_screen.dart';
import 'src/providers/client_provider.dart';
import 'src/providers/service_provider.dart';
import 'src/providers/event_provider.dart';

void main() {
  	runApp(
		MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (context) => ClientProvider()),
				ChangeNotifierProvider(create: (context) => ServiceProvider()),
				ChangeNotifierProvider(create: (context) => EventProvider()),
			],
			child: const MyApp(),
		),
	);
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		localizationsDelegates: AppLocalizations.localizationsDelegates,
		supportedLocales: AppLocalizations.supportedLocales,

		theme: ThemeData(
			primarySwatch: Colors.blue,
			visualDensity: VisualDensity.adaptivePlatformDensity,
		),

		home: const HomeScreen(),
		);
	}
}
