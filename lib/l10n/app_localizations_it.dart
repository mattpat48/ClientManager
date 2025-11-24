// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get helloWorld => 'Ciao Mondo!';

  @override
  String get calendarName => 'Calendario';

  @override
  String get clientsName => 'Clienti';

  @override
  String get settingsName => 'Impostazioni';

  @override
  String get noClientsMessage => 'Nessun cliente presente. Aggiungine uno!';

  @override
  String get noPhoneNumberMessage => 'Nessun numero di telefono';

  @override
  String get newClientNamePlacheholder => 'Nuovo Cliente';

  @override
  String get name => 'Nome';

  @override
  String get surname => 'Cognome';

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String get email => 'Email';

  @override
  String get address => 'Indirizzo';

  @override
  String get pleaseInsertName => 'Inserisci il nome';

  @override
  String get pleaseInsertSurname => 'Inserisci il cognome';

  @override
  String get pleaseInsertPhoneNumber => 'Inserisci il numero di telefono';

  @override
  String get pleaseInsertEmail => 'Inserisci l\'email';

  @override
  String get pleaseInsertAddress => 'Inserisci l\'indirizzo';
}
