// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get calendarName => 'Calendar';

  @override
  String get clientsName => 'Clients';

  @override
  String get settingsName => 'Settings';

  @override
  String get noClientsMessage => 'No clients found. Add a new one!';

  @override
  String get noPhoneNumberMessage => 'No phone number';

  @override
  String get newClientNamePlacheholder => 'New Client';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get pleaseInsertName => 'Please insert a name';

  @override
  String get pleaseInsertSurname => 'Please insert a surname';

  @override
  String get pleaseInsertPhoneNumber => 'Please insert a phone number';

  @override
  String get pleaseInsertEmail => 'Please insert an email';

  @override
  String get pleaseInsertAddress => 'Please insert an address';

  @override
  String get removeClientConfirmation =>
      'Do you really want to remove this client?';
}
