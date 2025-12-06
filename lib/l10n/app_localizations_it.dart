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
  String get customersName => 'Clienti';

  @override
  String get settingsName => 'Impostazioni';

  @override
  String get noCustomersMessage => 'Nessun cliente presente. Aggiungine uno!';

  @override
  String get noPhoneNumberMessage => 'Nessun numero di telefono';

  @override
  String get newCustomerNamePlacheholder => 'Nuovo Cliente';

  @override
  String get customer => 'Cliente';

  @override
  String get pleaseSelectCustomer => 'Seleziona un cliente';

  @override
  String get service => 'Servizio';

  @override
  String get pleaseSelectService => 'Seleziona un servizio';

  @override
  String get date => 'Data';

  @override
  String get pleaseSelectDate => 'Seleziona una data';

  @override
  String get startTime => 'Ora di inizio';

  @override
  String get endTime => 'Ora di fine';

  @override
  String get pleaseSelectTime => 'Seleziona un orario';

  @override
  String get endTimeAfterStartTimeError =>
      'L\'ora di fine deve essere dopo l\'ora di inizio!';

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

  @override
  String get removeCustomerConfirmation =>
      'Eliminare definitivamente questo cliente?';

  @override
  String get appointments => 'Appuntamenti';

  @override
  String get appointment => 'Appuntamento';

  @override
  String get noAppointmentsMessage => 'Nessun appuntamento presente.';

  @override
  String get servicesName => 'Servizi';

  @override
  String get noServicesMessage => 'Nessun servizio presente. Aggiungine uno!';

  @override
  String get newServiceNamePlaceholder => 'Nuovo Servizio';

  @override
  String get price => 'Prezzo';

  @override
  String get time => 'Tempo';

  @override
  String get pleaseInsertPrice => 'Inserisci un prezzo';

  @override
  String get removeServiceConfirmation =>
      'Eliminare definitivamente questo servizio?';

  @override
  String get newEventName => 'Nuovo Appuntamento';

  @override
  String get removeEventConfirmation =>
      'Eliminare definitivamente questo appuntamento?';
}
