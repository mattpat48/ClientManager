import 'package:clientmanager/src/providers/client.dart';
import 'package:clientmanager/src/providers/client_provider.dart';
import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/providers/event.dart';
import '../src/providers/event_provider.dart';
import '../src/providers/service.dart';

import '../src/providers/service_provider.dart';
class ServiceDetailsScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _isEditing = false;
  int touchedIndex = -1;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service.name);
    _priceController = TextEditingController(text: widget.service.currentPrice.toStringAsFixed(2));
    _timeController = TextEditingController(text: widget.service.time.toInt().toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      // Se si annulla, ripristina i valori originali
      _nameController.text = widget.service.name;
      _priceController.text = widget.service.currentPrice.toStringAsFixed(2);
      _timeController.text = widget.service.time.toInt().toString();
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Usa watch per far sì che il widget si ricostruisca quando i dati cambiano
    final serviceProvider = context.watch<ServiceProvider>();

    final eventProvider = context.watch<EventProvider>();
    final clientProvider = context.watch<ClientProvider>();

    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    // Ricarica il servizio dal provider per avere sempre i dati più aggiornati
    final currentService = serviceProvider.services.firstWhere((s) => s.id == widget.service.id, orElse: () => widget.service);

    // Filtra tutti gli eventi passati che includono questo servizio
    final relevantEvents = eventProvider.events
        .where((event) =>
            event.services.any((s) => s.id == currentService.id) &&
            event.date.isBefore(today))
        .toList();

    // Calcoli per gli ultimi 7 giorni
    final eventsLast7Days = relevantEvents
        .where((event) => event.date.isAfter(sevenDaysAgo))
        .toList();
    final uniqueClients7Days = eventsLast7Days.map((e) => e.customerId).toSet().length;
    final double earnings7Days = eventsLast7Days.fold(
        0.0,
        (sum, event) =>
            sum + currentService.getPriceForDate(event.date));

    // Calcoli per gli ultimi 30 giorni
    final eventsLast30Days = relevantEvents
        .where((event) => event.date.isAfter(thirtyDaysAgo))
        .toList();
    final uniqueClients30Days = eventsLast30Days.map((e) => e.customerId).toSet().length;
    final double earnings30Days = eventsLast30Days.fold(
        0.0,
        (sum, event) =>
            sum + currentService.getPriceForDate(event.date));

    // Dati per il grafico a torta
    // Calcoli totali
    final totalUniqueClients = relevantEvents.map((e) => e.customerId).toSet().length;
    final double totalEarnings = relevantEvents.fold(
        0.0,
        (sum, event) => sum + currentService.getPriceForDate(event.date));

    final Map<String, int> clientUsage = {};
    for (var event in relevantEvents) {
      clientUsage.update(event.customerId, (value) => value + 1,
          ifAbsent: () => 1);
    }

    final sortedClients = clientUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calcolo guadagno per cliente
    final Map<String, double> clientEarnings = {};
    for (var event in relevantEvents) {
      final priceForDate = currentService.getPriceForDate(event.date);
      clientEarnings.update(event.customerId, (value) => value + priceForDate, ifAbsent: () => priceForDate);
    }

    final sortedClientEarnings = clientEarnings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(_isEditing ? l10n.editService : currentService.name),
        centerTitle: true,
        titleTextStyle:
            Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
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
                  final updatedService = currentService.copyWith(
                    name: _nameController.text,
                    time: int.parse(_timeController.text),
                  );

                  final newPrice = double.parse(_priceController.text);
                  if (newPrice != updatedService.currentPrice) {
                    updatedService.addPrice(newPrice, DateTime.now());
                  }

                  serviceProvider.updateService(updatedService);
                }
                _toggleEdit();
              },
            ),
          ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card Dettagli Servizio e Modifica
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isEditing
                  ? _buildEditingView(l10n)
                  : _buildDetailsView(context, l10n, currentService),
            ),
          ),
          const SizedBox(height: 16),

          // Card Statistiche (Espandibile)
          Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: const Icon(Icons.bar_chart),
              title: Text(l10n.statistics, style: Theme.of(context).textTheme.titleLarge),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildStatSection(l10n.totalStats, {
                        l10n.customerServed: totalUniqueClients.toString(),
                        l10n.earnings: '€${totalEarnings.toStringAsFixed(2)}',
                      }),
                      const Divider(height: 24),
                      _buildStatSection(l10n.last7days, {
                        l10n.customerServed: uniqueClients7Days.toString(),
                        l10n.earnings: '€${earnings7Days.toStringAsFixed(2)}',
                      }),
                      const Divider(height: 24),
                      _buildStatSection(l10n.last30days, {
                        l10n.customerServed: uniqueClients30Days.toString(),
                        l10n.earnings: '€${earnings30Days.toStringAsFixed(2)}',
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Card Utilizzo Cliente (Espandibile)
          if (sortedClients.isNotEmpty)
            Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                leading: const Icon(Icons.pie_chart),
                title: Text(l10n.clientUsage, style: Theme.of(context).textTheme.titleLarge),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPieChart(sortedClients, clientProvider, l10n),
                        const Divider(height: 30),
                        Text(l10n.totalIncomePerClient, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16.0),
                        ...sortedClientEarnings.map((entry) {
                          final clientName = clientProvider.clients
                              .firstWhere((c) => c.id == entry.key, orElse: () => Client(id: '', name: l10n.unknown))
                              .name;
                          return _buildStatRow(clientName, '€${entry.value.toStringAsFixed(2)}');
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Funzione per visualizzare lo storico dei prezzi
  void _showPriceHistory(BuildContext context, Service service) {
    // Implementazione futura
  }

  Widget _buildDetailsView(BuildContext context, AppLocalizations l10n, Service service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.details, style: Theme.of(context).textTheme.titleLarge),
        const Divider(height: 20),
        _buildStatRow(l10n.price, '€${service.currentPrice.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        _buildStatRow(l10n.time, '${service.time.toInt()} min'),
      ],
    );
  }

  Widget _buildEditingView(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.editService, style: Theme.of(context).textTheme.titleLarge),
        const Divider(height: 20),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: l10n.name, icon: const Icon(Icons.miscellaneous_services)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _priceController,
          decoration: InputDecoration(labelText: l10n.price, icon: const Icon(Icons.euro)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _timeController,
          decoration: InputDecoration(labelText: l10n.time, icon: const Icon(Icons.timer)),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildStatSection(String title, Map<String, String> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...stats.entries.map((entry) => _buildStatRow(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildPieChart(List<MapEntry<String, int>> sortedClients, ClientProvider clientProvider, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
                  sortedClients.length > 5 ? 5 : sortedClients.length,
                  (i) {
                    final isTouched = i == touchedIndex;
                    final radius = isTouched ? 50.0 : 40.0;
                    final clientEntry = sortedClients[i];
                    return PieChartSectionData(
                      showTitle: false,
                      color: Colors.primaries[i % Colors.primaries.length],
                      value: clientEntry.value.toDouble(),
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
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              sortedClients.length > 5 ? 5 : sortedClients.length,
              (i) {
                final clientEntry = sortedClients[i];
                final clientName = clientProvider.clients
                    .firstWhere((c) => c.id == clientEntry.key, orElse: () => Client(id: '', name: l10n.unknown))
                    .name;
                return _buildLegendItem(
                  color: Colors.primaries[i % Colors.primaries.length],
                  text: '$clientName (${clientEntry.value})',
                );
              },
            ),
          ),
        ),
      ],
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