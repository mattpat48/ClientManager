import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    // Il contenuto della tua schermata Calendario va qui.
    // Per ora, è un semplice testo centrato.
    return const Center(child: Text('Pagina Calendario'));
  }
}