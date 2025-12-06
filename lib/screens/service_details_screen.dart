import 'package:clientmanager/src/providers/client.dart';
import 'package:clientmanager/src/providers/client_provider.dart';
import 'package:clientmanager/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/providers/event.dart';
import '../src/providers/event_provider.dart';
import '../src/providers/service.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final eventProvider = context.watch<EventProvider>();
    final clientProvider = context.watch<ClientProvider>();

    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    // Filtra tutti gli eventi passati che includono questo servizio
    final relevantEvents = eventProvider.events
        .where((event) =>
            event.services.contains(widget.service) &&
            event.date.isBefore(today))
        .toList();

    // Calcoli per gli ultimi 7 giorni
    final eventsLast7Days = relevantEvents
        .where((event) => event.date.isAfter(sevenDaysAgo))
        .toList();
    final uniqueClients7Days =
        eventsLast7Days.map((e) => e.customerId).toSet().length;
    final earnings7Days = eventsLast7Days.length * widget.service.price;

    // Calcoli per gli ultimi 30 giorni
    final eventsLast30Days = relevantEvents
        .where((event) => event.date.isAfter(thirtyDaysAgo))
        .toList();
    final uniqueClients30Days =
        eventsLast30Days.map((e) => e.customerId).toSet().length;
    final earnings30Days = eventsLast30Days.length * widget.service.price;

    // Dati per il grafico a torta
    // Calcoli totali
    final totalUniqueClients =
        relevantEvents.map((e) => e.customerId).toSet().length;
    final totalEarnings = relevantEvents.length * widget.service.price;

    final Map<String, int> clientUsage = {};
    for (var event in relevantEvents) {
      clientUsage.update(event.customerId, (value) => value + 1,
          ifAbsent: () => 1);
    }

    final sortedClients = clientUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatCard(
            title: l10n.totalStats,
            stats: {
              l10n.customerServed: totalUniqueClients.toString(),
              l10n.earnings: '€${totalEarnings.toStringAsFixed(2)}',
            },
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: l10n.last7days,
            stats: {
              l10n.customerServed: uniqueClients7Days.toString(),
              l10n.earnings: '€${earnings7Days.toStringAsFixed(2)}',
            },
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: l10n.last30days,
            stats: {
              l10n.customerServed: uniqueClients30Days.toString(),
              l10n.earnings: '€${earnings30Days.toStringAsFixed(2)}',
            },
          ),
          const SizedBox(height: 16),
          if (sortedClients.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.clientUsage,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: List.generate(
                                  sortedClients.length > 5 ? 5 : sortedClients.length,
                                  (i) {
                                    final isTouched = i == touchedIndex;
                                    final radius = isTouched ? 60.0 : 50.0;
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              sortedClients.length > 5 ? 5 : sortedClients.length,
                              (i) {
                                final clientEntry = sortedClients[i];
                                final clientName = clientProvider.clients
                                    .firstWhere((c) => c.id == clientEntry.key,
                                        orElse: () => Client(id: '', name: l10n.unknown))
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
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      {required String title, required Map<String, String> stats}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            ...stats.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: Theme.of(context).textTheme.bodyLarge),
                    Text(entry.value,
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
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