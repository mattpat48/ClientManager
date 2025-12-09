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
  String get customersName => 'Customers';

  @override
  String get settingsName => 'Settings';

  @override
  String get noCustomersMessage => 'No customers found. Add a new one!';

  @override
  String get noPhoneNumberMessage => 'No phone number';

  @override
  String get newCustomerNamePlacheholder => 'New Customer';

  @override
  String get customer => 'Customer';

  @override
  String get pleaseSelectCustomer => 'Please select a customer';

  @override
  String get service => 'Service';

  @override
  String get pleaseSelectService => 'Please select a service';

  @override
  String get date => 'Date';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get pleaseSelectTime => 'Please Select Time';

  @override
  String get endTimeAfterStartTimeError => 'End time must be after start time!';

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
  String get removeCustomerConfirmation =>
      'Do you really want to remove this customer?';

  @override
  String get appointments => 'Appointments';

  @override
  String get appointment => 'Appointment';

  @override
  String get noAppointmentsMessage => 'No appointments found. Add a new one!';

  @override
  String get servicesName => 'Services';

  @override
  String get noServicesMessage => 'No services found. Add a new one!';

  @override
  String get newServiceNamePlaceholder => 'New Service';

  @override
  String get price => 'Price';

  @override
  String get time => 'Time';

  @override
  String get pleaseInsertPrice => 'Please insert a price';

  @override
  String get removeServiceConfirmation =>
      'Do you really want to remove this service?';

  @override
  String get newEventName => 'New Event';

  @override
  String get removeEventConfirmation =>
      'Do you really want to remove this event?';

  @override
  String get last7days => 'Last 7 days';

  @override
  String get last30days => 'Last 30 days';

  @override
  String get totalStats => 'All Time';

  @override
  String get customerServed => 'Served customers';

  @override
  String get earnings => 'Earnings';

  @override
  String get clientUsage => 'Most frequent customers';

  @override
  String get unknown => 'Unknown';

  @override
  String get statistics => 'Statistics';

  @override
  String get avgExpensePerAppointment => 'Average expense per appointment';

  @override
  String get usedServices => 'Utilized Services';

  @override
  String get totalIncomePerService => 'Total income per service';

  @override
  String get editClient => 'Edit customer';

  @override
  String get appointmentsHistory => 'Appointment history';

  @override
  String get exportData => 'Export Data';

  @override
  String get importData => 'Import Data';

  @override
  String get warning => 'Warning!';

  @override
  String get overWriting =>
      'By importing this file, you will over-write all data saved on this app. Would you like to continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get importSuccess => 'Data imported successfully!';

  @override
  String get importError => 'Error during data import.';

  @override
  String get invalidFileFormat => 'Invalid file format.';

  @override
  String get exportSuccess => 'Data exported successfully!';

  @override
  String get exportError => 'Error during data export.';

  @override
  String get editService => 'Edit service';

  @override
  String get details => 'Details';
}
