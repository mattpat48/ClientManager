import 'package:clientmanager/screens/event_manage_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../src/providers/client.dart';
import '../src/providers/client_provider.dart';
import '../src/providers/event_provider.dart';
import '../src/providers/service.dart';

class ClientScreen extends StatefulWidget {
	final Client client;

	const ClientScreen({super.key, required this.client});

	@override
	State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {	
  bool _isEditing = false;
  int touchedIndex = -1;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _phoneController = TextEditingController(text: widget.client.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    _nameController.text = widget.client.name;
    _phoneController.text = widget.client.phoneNumber ?? '';
    setState(() => _isEditing = !_isEditing);
  }

	@override
	Widget build(BuildContext context) {
		final l10n = AppLocalizations.of(context)!;
		final eventProvider = context.watch<EventProvider>();

		// Tutti gli eventi del cliente per le statistiche storiche
		final allClientEvents = eventProvider.events
				.where((event) => event.customerId == widget.client.id)
				.toList();

		// Eventi futuri da mostrare nella lista
		final today = DateTime.now();
		final startOfToday = DateTime(today.year, today.month, today.day);
		final upcomingEvents = allClientEvents
				.where((event) => !event.date.isBefore(startOfToday))
				.toList()..sort((a, b) => a.date.compareTo(b.date));

		final pastEvents = allClientEvents
				.where((event) => event.date.isBefore(startOfToday))
				.toList()..sort((a, b) => b.date.compareTo(a.date));

		// 1. Calcolo spesa media per appuntamento
		final double totalSpending = allClientEvents.fold(
			0.0,
			(sum, event) => sum + event.services.fold(0.0, (s, service) => s + service.getPriceForDate(event.date)));
		final double averageSpending = allClientEvents.isNotEmpty ? totalSpending / allClientEvents.length : 0.0;

		// 2. Dati per grafico e spesa per servizio
		final Map<Service, int> serviceUsage = {};
		final Map<Service, double> serviceSpending = {};


		for (var event in allClientEvents) {
			for (var service in event.services) {
				final priceForDate = service.getPriceForDate(event.date);
				serviceUsage.update(service, (value) => value + 1, ifAbsent: () => 1);
				serviceSpending.update(service, (value) => value + priceForDate, ifAbsent: () => priceForDate);
			}
		}

		final sortedServiceUsage = serviceUsage.entries.toList()
			..sort((a, b) => b.value.compareTo(a.value));

		return Scaffold(
			appBar: AppBar(
				title: Text(_isEditing ? l10n.editClient : widget.client.name),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _toggleEdit,
            ),
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                // Salva le modifiche
                final clientProvider = context.read<ClientProvider>();
                setState(() {
                  widget.client.name = _nameController.text;
                  widget.client.phoneNumber = _phoneController.text;
                  clientProvider.updateClient(widget.client);
                });
              }
              _toggleEdit();
            },
          ),
        ],
			),
			body: ListView(
				padding: const EdgeInsets.all(16.0),
				children: [
          if (_isEditing)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        icon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
					Card(
						child: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(l10n.appointments, style: Theme.of(context).textTheme.headlineSmall),
									const SizedBox(height: 10),
									upcomingEvents.isEmpty
										? Center(child: Padding(
											padding: const EdgeInsets.symmetric(vertical: 16.0),
											child: Text(l10n.noAppointmentsMessage),
										))
										: ListView.separated(
											shrinkWrap: true,
											physics: const NeverScrollableScrollPhysics(),
											itemCount: upcomingEvents.length,
											separatorBuilder: (context, index) => const Divider(),
											itemBuilder: (context, index) {
												final event = upcomingEvents[index];
												return ListTile(
													title: Text(DateFormat.yMMMd().format(event.date)),
													subtitle: Text(event.services.map((s) => s.name).join(', ')),
													trailing: Text(event.startTime.format(context)),
													onTap: () => Navigator.of(context).push(MaterialPageRoute(
														builder: (context) => EventManageScreen(existingEvent: event))),
												);
											},
										),
								],
							),
						),
					),
					const SizedBox(height: 16),

					// Card Statistiche Generali
					Card(
						child: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(l10n.statistics, style: Theme.of(context).textTheme.titleLarge),
									const Divider(height: 20),
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Text(l10n.avgExpensePerAppointment, style: Theme.of(context).textTheme.bodyLarge),
											Text('€${averageSpending.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
										],
									)
								],
							),
						),
					),
					const SizedBox(height: 16),

					// Card Analisi Servizi
					if (sortedServiceUsage.isNotEmpty)
						Card(
							child: Padding(
								padding: const EdgeInsets.all(16.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(l10n.usedServices, style: Theme.of(context).textTheme.titleLarge),
										const SizedBox(height: 20),
										Row(
											children: [
												Expanded(
													child: SizedBox(
														height: 150,
														child: PieChart(
															PieChartData(
																pieTouchData: PieTouchData(
																	touchCallback: (FlTouchEvent event, pieTouchResponse) {
																		setState(() {
																			if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
																				touchedIndex = -1;
																				return;
																			}
																			touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
																		});
																	},
																),
																borderData: FlBorderData(show: false),
																sectionsSpace: 2,
																centerSpaceRadius: 30,
																sections: List.generate(
																	sortedServiceUsage.length > 5 ? 5 : sortedServiceUsage.length, (i) {
																		final isTouched = i == touchedIndex;
																		final radius = isTouched ? 50.0 : 40.0;
																		final entry = sortedServiceUsage[i];
																		return PieChartSectionData(
																			showTitle: false,
																			color: Colors.primaries[i % Colors.primaries.length],
																			value: entry.value.toDouble(),
																			radius: radius,
																		);
																	},
																),
															),
														),
													),
												),
												const SizedBox(width: 20),
												Expanded(
													child: Column(
														mainAxisAlignment: MainAxisAlignment.center,
														crossAxisAlignment: CrossAxisAlignment.start,
														children: List.generate(
															sortedServiceUsage.length > 5 ? 5 : sortedServiceUsage.length, (i) {
																final entry = sortedServiceUsage[i];
																return _buildLegendItem(
																	color: Colors.primaries[i % Colors.primaries.length],
																	text: '${entry.key.name} (${entry.value})',
																);
															},
														),
													),
												),
											],
										),
										const Divider(height: 30),
                    Text(l10n.totalIncomePerService, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8.0),
										...serviceSpending.entries.map((entry) {
											return Padding(
												padding: const EdgeInsets.only(bottom: 8.0),
												child: Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														Text(entry.key.name, style: Theme.of(context).textTheme.bodyLarge),
														Text('€${entry.value.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
													],
												),
											);
										}),
									],
								),
							),
						),

					// Card Cronologia Appuntamenti
					const SizedBox(height: 16),
					Card(
						child: Padding(
							padding: const EdgeInsets.all(16.0),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(l10n.appointmentsHistory, style: Theme.of(context).textTheme.headlineSmall),
									const SizedBox(height: 10),
									pastEvents.isEmpty
										? Center(child: Padding(
											padding: const EdgeInsets.symmetric(vertical: 16.0),
											child: Text(l10n.noAppointmentsMessage),
										))
										: ListView.separated(
											shrinkWrap: true,
											physics: const NeverScrollableScrollPhysics(),
											itemCount: pastEvents.length,
											separatorBuilder: (context, index) => const Divider(),
											itemBuilder: (context, index) {
												final event = pastEvents[index];
												final eventCost = event.services.fold(0.0, (sum, service) => sum + service.getPriceForDate(event.date));
												return ListTile(
													title: Text(DateFormat.yMMMd().format(event.date)),
													subtitle: Text(event.services.map((s) => s.name).join(', ')),
													trailing: Text('€${eventCost.toStringAsFixed(2)}'),
													onTap: () => Navigator.of(context).push(MaterialPageRoute(
														builder: (context) => EventManageScreen(existingEvent: event))),
												);
											},
										),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildLegendItem({required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}