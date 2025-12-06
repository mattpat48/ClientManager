import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'screens/calendar_screen.dart';
import 'screens/clients_screen.dart';
import 'screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  	const HomeScreen({super.key});

  	@override
  	State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  	int _selectedIndex = 0;

	// Lista dei widget delle schermate che verranno mostrati.
	static const List<Widget> _screenOptions = <Widget>[
		CalendarScreen(),
		ClientsScreen(),
		SettingsScreen(),
	];

	void _onItemTapped(int index) {
		setState(() {
		_selectedIndex = index;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
		body: _screenOptions.elementAt(_selectedIndex),
		bottomNavigationBar: BottomNavigationBar(
			items: <BottomNavigationBarItem>[
			BottomNavigationBarItem(
				icon: Icon(Icons.calendar_today),
				label: AppLocalizations.of(context)!.calendarName,
			),
			BottomNavigationBarItem(
				icon: Icon(Icons.people),
				label: AppLocalizations.of(context)!.customersName,
			),
			BottomNavigationBarItem(
				icon: Icon(Icons.settings),
				label: AppLocalizations.of(context)!.settingsName,
			),
			],
			currentIndex: _selectedIndex,
			onTap: _onItemTapped,
		),
		);
	}
}