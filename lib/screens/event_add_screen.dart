import 'package:flutter/material.dart';
import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../src/providers/client.dart';
import '../src/providers/client_provider.dart';
import '../src/providers/service.dart';
import '../src/providers/service_provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../src/providers/event.dart';
import '../src/providers/event_provider.dart';

class EventAddScreen extends StatefulWidget {
  final DateTime? date;

  const EventAddScreen({super.key, required this.date});

  @override
  State<EventAddScreen> createState() => _EventAddScreenState();
}

class _EventAddScreenState extends State<EventAddScreen> {
  final _formKey = GlobalKey<FormState>();
  Client? _selectedClient;
  List<Service> _selectedServices = [];  
  DateTime? _selectedDate;
  TimeOfDay? _startTime = TimeOfDay.now();
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newEventName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveEvent,
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer2<ClientProvider, ServiceProvider>(
                        builder: (context, clientProvider, serviceProvider, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(l10n.date),
                            subtitle: Text(_selectedDate == null
                                ? l10n.pleaseSelectDate
                                : DateFormat.yMMMd().format(_selectedDate!)),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2050),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                });
                              }
                            },
                          ),
                          const Divider(),
                          DropdownButtonFormField<Client>(
                            initialValue: _selectedClient,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                labelText: l10n.customer,
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10.0)),
                            items: clientProvider.clients.map((Client client) {
                              return DropdownMenuItem<Client>(
                                value: client,
                                child: Text(client.name),
                              );
                            }).toList(),
                            onChanged: (Client? newValue) {
                              setState(() {
                                _selectedClient = newValue;
                              });
                            },
                            validator: (value) =>
                                value == null ? l10n.pleaseSelectCustomer : null,
                          ),
                          const Divider(),
                          MultiSelectDialogField<Service>(
                            dialogHeight: MediaQuery.of(context).size.height * 0.4,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration:
                                const BoxDecoration(border: Border(bottom: BorderSide.none)),
                            items: serviceProvider.services
                                .map((service) =>
                                    MultiSelectItem<Service>(service, service.name))
                                .toList(),
                            title: Text(l10n.service),
                            buttonText: Text(l10n.service),
                            onConfirm: (values) {
                              setState(() {
                                _selectedServices = values;
                              });
                              _setEndTime();
                            },
                            validator: (values) =>
                                (values == null || values.isEmpty)
                                    ? l10n.pleaseSelectService
                                    : null,
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() {
                                  _selectedServices.remove(value);
                                });
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(l10n.startTime),
                            subtitle: Text(_startTime == null
                                ? l10n.pleaseSelectTime
                                : _formatTime(_startTime!)),
                            onTap: () => _pickTime(true),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.access_time_filled),
                            title: Text(l10n.endTime),
                            subtitle: Text(_endTime == null
                                ? l10n.pleaseSelectTime
                                : _formatTime(_endTime!)),
                            onTap: () => _pickTime(false),
                            enabled: _startTime != null,
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _pickTime(bool isStartTime) async {
    final initialTime = isStartTime
        ? (_startTime ?? TimeOfDay.now())
        : (_endTime ?? _startTime ?? TimeOfDay.now());

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
          // Opzionale: resetta l'ora di fine se è precedente a quella di inizio
          if (_endTime != null &&
              (pickedTime.hour > _endTime!.hour ||
                  (pickedTime.hour == _endTime!.hour &&
                      pickedTime.minute >= _endTime!.minute))) {
            _endTime = null;
          }
          _setEndTime();
        } else {
          // Controllo per l'ora di fine
          if (_startTime != null &&
              (pickedTime.hour < _startTime!.hour ||
                  (pickedTime.hour == _startTime!.hour &&
                      pickedTime.minute <= _startTime!.minute))) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.endTimeAfterStartTimeError)),
            );
          } else {
            _endTime = pickedTime;
          }
        }
      });
    }
  }

  void _saveEvent() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null) {
      final eventProvider = context.read<EventProvider>();
      final clientProvider = context.read<ClientProvider>();

      // Ulteriore controllo di sicurezza sull'orario
      if (_endTime!.hour < _startTime!.hour ||
          (_endTime!.hour == _startTime!.hour &&
              _endTime!.minute <= _startTime!.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.endTimeAfterStartTimeError)),
        );
        return;
      }

      final newEvent = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDate!,
        startTime: _startTime!,
        endTime: _endTime!,
        customerId: _selectedClient!.id,
        services: _selectedServices,
      );

      eventProvider.addEvent(newEvent);
      _selectedClient!.appointments.add(newEvent.id);
      clientProvider.updateClient(_selectedClient!);

      Navigator.of(context).pop();
    }
  }
  
  void _setEndTime() {
    if (_selectedServices.isNotEmpty && _startTime != null) {
      int totalMinutes = _selectedServices.fold(0, (sum, service) => sum + service.time.toInt());
      DateTime startDateTime = DateTime(2000, 1, 1, _startTime!.hour, _startTime!.minute);
      DateTime endDateTime = startDateTime.add(Duration(minutes: totalMinutes));
      _endTime = TimeOfDay.fromDateTime(endDateTime);
    }
  }
}