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

class EventManageScreen extends StatefulWidget {
  final DateTime? date;
  final Event? existingEvent;
  
  const EventManageScreen({super.key, this.date, this.existingEvent}) : assert(date != null || existingEvent != null);

  @override
  State<EventManageScreen> createState() => _EventManageScreenState();
}

class _EventManageScreenState extends State<EventManageScreen> {
  final _formKey = GlobalKey<FormState>();
  Client? _selectedClient;
  List<Service> _selectedServices = [];  
  DateTime? _selectedDate;
  TimeOfDay? _startTime = TimeOfDay.now();
  TimeOfDay? _endTime;
  late TextEditingController _noteController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingEvent != null) {
      final event = widget.existingEvent!;
      _selectedDate = event.date;
      _startTime = event.startTime;
      _endTime = event.endTime;
      _selectedServices = List<Service>.from(event.services);
      _noteController = TextEditingController(text: event.note ?? '');
      _dateController = TextEditingController();
      _startTimeController = TextEditingController();
      _endTimeController = TextEditingController();

      // Recupera il cliente dopo che il widget è stato costruito
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final clientProvider = Provider.of<ClientProvider>(context, listen: false);
        final matchingClients = clientProvider.clients.where((c) => c.id == event.customerId);
        if (mounted && matchingClients.isNotEmpty) {
          setState(() {
            _selectedClient = matchingClients.first;
          });
        }
      });
    } else {
      _selectedDate = widget.date;
      _noteController = TextEditingController();
      _dateController = TextEditingController();
      _startTimeController = TextEditingController();
      _endTimeController = TextEditingController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _updateDateText();
      if (widget.existingEvent != null) {
        _updateStartTimeText();
        _updateEndTimeText();
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _updateDateText() {
    if (_selectedDate != null) {
      _dateController.text = DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(_selectedDate!);
    }
  }

  void _updateStartTimeText() {
    if (_startTime != null) {
      _startTimeController.text = _startTime!.format(context);
    }
  }

  void _updateEndTimeText() {
    if (_endTime != null) {
      _endTimeController.text = _endTime!.format(context);
    }
  }

  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final clientProvider = context.watch<ClientProvider>();

    String appBarTitle = l10n.newEventName;
    if (widget.existingEvent != null && _selectedClient != null) {
      appBarTitle =
          '${_selectedClient!.name} - ${DateFormat.yMMMd().format(_selectedDate!)} - ${_formatTime(_startTime!)}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(appBarTitle),
        centerTitle: true,
        titleTextStyle:
            Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveEvent,
        child: const Icon(Icons.check),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<Client>(
              initialValue: _selectedClient,
              decoration: InputDecoration(
                labelText: l10n.customer,
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
              validator: (value) => value == null ? l10n.pleaseSelectCustomer : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: l10n.date,
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onTap: _pickDate,
              validator: (value) => (value == null || value.isEmpty) ? l10n.pleaseSelectDate : null,
            ),
            const SizedBox(height: 16),
            Consumer<ServiceProvider>(builder: (context, serviceProvider, child) {
              return InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.design_services),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                ),
                child: MultiSelectDialogField<Service>(
                  dialogHeight: MediaQuery.of(context).size.height * 0.4,
                  initialValue: _selectedServices,
                  items: serviceProvider.services.map((service) => MultiSelectItem<Service>(service, service.name)).toList(),
                  title: Text(l10n.service),
                  buttonText: Text(l10n.service),
                  decoration: const BoxDecoration(),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  onConfirm: (values) {
                    setState(() {
                      _selectedServices = values;
                    });
                    _setEndTime();
                  },
                  validator: (values) => (values == null || values.isEmpty) ? l10n.pleaseSelectService : null,
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedServices.remove(value);
                        _setEndTime();
                      });
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.startTime,
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onTap: () => _pickTime(true),
                    validator: (value) => (value == null || value.isEmpty) ? l10n.pleaseSelectTime : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _endTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: l10n.endTime,
                      prefixIcon: const Icon(Icons.access_time_filled),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onTap: () => _pickTime(false),
                    validator: (value) => (value == null || value.isEmpty) ? l10n.pleaseSelectTime : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: l10n.noteLabel,
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _updateDateText();
      });
    }
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
          _updateStartTimeText();
          // Opzionale: resetta l'ora di fine se è precedente a quella di inizio
          if (_endTime != null &&
              (pickedTime.hour > _endTime!.hour ||
                  (pickedTime.hour == _endTime!.hour &&
                      pickedTime.minute >= _endTime!.minute))) {
            _endTime = null;
            _endTimeController.text = '';
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
            _updateEndTimeText();
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
      final clientProvider = context.read<ClientProvider>(); // No need to watch, just read

      if (_endTime!.hour < _startTime!.hour ||
          (_endTime!.hour == _startTime!.hour &&
              _endTime!.minute <= _startTime!.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.endTimeAfterStartTimeError)),
        );
        return;
      }
      
      if (widget.existingEvent != null) {
        // Modifica evento esistente
        final oldEvent = widget.existingEvent!;
        final updatedEvent = Event(
          id: oldEvent.id,
          date: _selectedDate!,
          startTime: _startTime!,
          endTime: _endTime!,
          customerId: _selectedClient!.id,
          services: _selectedServices,
          note: _noteController.text,
        );

        // Se il cliente è cambiato, aggiorna entrambi i clienti
        if (oldEvent.customerId != _selectedClient!.id) {
          Client oldClient = clientProvider.clients.firstWhere((c) => c.id == oldEvent.customerId);
          oldClient.appointments.remove(oldEvent.id);
          clientProvider.updateClient(oldClient);

          _selectedClient!.appointments.add(oldEvent.id);
          clientProvider.updateClient(_selectedClient!);
        }
        eventProvider.updateEvent(updatedEvent);
      } else {
        // Aggiungi nuovo evento
        final newEvent = Event(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: _selectedDate!,
          startTime: _startTime!,
          endTime: _endTime!,
          customerId: _selectedClient!.id,
          services: _selectedServices,
          note: _noteController.text,
        );
        eventProvider.addEvent(newEvent);
        _selectedClient!.appointments.add(newEvent.id);
        clientProvider.updateClient(_selectedClient!);
      }

      Navigator.of(context).pop();
    }
  }
  
  void _setEndTime() {
    if (_selectedServices.isNotEmpty && _startTime != null) {
      int totalMinutes = _selectedServices.fold(0, (sum, service) => sum + service.time.toInt());
      DateTime startDateTime = DateTime(2000, 1, 1, _startTime!.hour, _startTime!.minute);
      DateTime endDateTime = startDateTime.add(Duration(minutes: totalMinutes));
      _endTime = TimeOfDay.fromDateTime(endDateTime);
      _updateEndTimeText();
    }
  }
}