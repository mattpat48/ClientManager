import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:clientmanager/src/providers/client_provider.dart';
import 'package:clientmanager/src/providers/client.dart';
import 'package:clientmanager/src/providers/event_provider.dart';
import '../src/providers/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event_manage_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime? _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();

  Future<void> _showRemoveEventDialog(Event event) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final clientProvider = context.read<ClientProvider>();
        return AlertDialog(
          title: Text('${clientProvider.clients.where((client) => client.id == event.customerId).first.name}, ${event.startTime.format(context)} - ${event.endTime.format(context)}'),
          content: Text(l10n.removeEventConfirmation),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.confirm),
              onPressed: () {
                final eventProvider = context.read<EventProvider>();
                final clientProvider = context.read<ClientProvider>();

                // Rimuovi l'appuntamento dal cliente
                Client client = clientProvider.clients.firstWhere((c) => c.id == event.customerId);
                client.appointments.remove(event.id);
                clientProvider.updateClient(client);

                // Rimuovi l'evento
                eventProvider.removeEvent(event.id);
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
    final eventProvider = context.watch<EventProvider>();
    final clientProvider = context.watch<ClientProvider>();

    List<Event>? selectedDayEvents = eventProvider.events.where((event) => isSameDay(event.date, _selectedDay)).toList();


    selectedDayEvents.sort((a, b) {
      final aTime = a.startTime.hour * 60 + a.startTime.minute;
      final bTime = b.startTime.hour * 60 + b.startTime.minute;
      return aTime.compareTo(bTime);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calendarName),
      ),
      body: Padding(padding: EdgeInsets.all(10.0), child:
      Column(
        children: [
          TableCalendar<Event>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            headerStyle: const HeaderStyle(
              // Nasconde il pulsante per cambiare il formato (es. "2 weeks")
              formatButtonVisible: false,
              titleCentered: true,
            ),

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
                _focusedDay = focusedDay;
              });
            },

            startingDayOfWeek: StartingDayOfWeek.monday,
            holidayPredicate: (day) {
              const holidays = {
                '1-1',   // Capodanno
                '1-6',   // Epifania
                '4-25',  // Festa della Liberazione
                '5-1',   // Festa del Lavoro
                '6-2',   // Festa della Repubblica
                '8-15',  // Ferragosto (Assunzione)
                '11-1',  // Ognissanti (Tutti i Santi)
                '12-8',  // Immacolata Concezione
                '12-25', // Natale
                '12-26', // Santo Stefano
              };

              // Considera festivo se è domenica
              if (day.weekday == DateTime.sunday) return true;

              // Considera festivo se è una delle date fisse
              return holidays.contains('${day.month}-${day.day}');
            }
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: selectedDayEvents.length,
              itemBuilder: (context, index) {
                final event = selectedDayEvents[index];
                final hasNote = event.note != null && event.note!.isNotEmpty;
                return Card(
                  child: ListTile(
                    isThreeLine: hasNote,
                    title: Text(
                      '${clientProvider.clients.where((client) => client.id == event.customerId).first.name}, ${event.startTime.format(context)} - ${event.endTime.format(context)}'
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.services.map((service) => service.name).join(', ')),
                        if (hasNote)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Note: ${event.note!}',
                              style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodySmall?.color),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventManageScreen(existingEvent: event))),
                    onLongPress: () => _showRemoveEventDialog(event),
                  ),
                );
              },
            ),
          ),
        ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventManageScreen(date: _selectedDay))),
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}