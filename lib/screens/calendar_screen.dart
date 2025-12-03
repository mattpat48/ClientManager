import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:clientmanager/src/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

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

    List<Event> _getEventsForDay(DateTime day) {
      return events[day] ?? [];
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendarName),
      ),
      body: Consumer<ClientProvider> (
        builder: (context, clientProvider, child) {
          return TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            eventLoader: (day) {
              return _getEventsForDay(day);
            },

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
          );
        }
      )
    );
  }
}