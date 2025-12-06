import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../src/providers/client.dart';
import '../src/providers/event_provider.dart';

class ClientScreen extends StatefulWidget {
	final Client client;

	const ClientScreen({super.key, required this.client});

	@override
	State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
	@override
	Widget build(BuildContext context) {
		// Usiamo 'watch' per ascoltare i cambiamenti nell'EventProvider.
		final eventProvider = context.watch<EventProvider>();
		final clientEvents = eventProvider.events
				.where((event) => event.customerId == widget.client.id)
				.toList();
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.client.name),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(AppLocalizations.of(context)!.appointments, style: Theme.of(context).textTheme.headlineSmall),
						const SizedBox(height: 10),
						Expanded(
							child: clientEvents.isEmpty
								? Center(child: Text(AppLocalizations.of(context)!.noAppointmentsMessage))
								: ListView.builder(
									itemCount: clientEvents.length,
									itemBuilder: (context, index) {
										final event = clientEvents[index];
										return Card(
											child: ListTile(
												title: Text(DateFormat.yMMMd().format(event.date)),
												subtitle: Text(event.services.map((s) => s.name).join(', ')),
											),
										);
									},
								),
						),
					],
				),
			),
		);
	}
}