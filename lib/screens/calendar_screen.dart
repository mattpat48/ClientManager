import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:clientmanager/src/providers/event_provider.dart';
import '../src/providers/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event_add_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime? _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendarName),
      ),
      body: TableCalendar<Event>(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),

        // Carica gli eventi per un dato giorno
        eventLoader: (day) {
          return eventProvider.events.where((event) {
            return isSameDay(event.date, day);
          }).toList();
        },

        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },

        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventAddScreen(date: _selectedDay))),
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}