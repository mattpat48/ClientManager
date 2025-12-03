import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @calendarName.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarName;

  /// No description provided for @clientsName.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsName;

  /// No description provided for @settingsName.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsName;

  /// No description provided for @noClientsMessage.
  ///
  /// In en, this message translates to:
  /// **'No clients found. Add a new one!'**
  String get noClientsMessage;

  /// No description provided for @noPhoneNumberMessage.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhoneNumberMessage;

  /// No description provided for @newClientNamePlacheholder.
  ///
  /// In en, this message translates to:
  /// **'New Client'**
  String get newClientNamePlacheholder;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @pleaseInsertName.
  ///
  /// In en, this message translates to:
  /// **'Please insert a name'**
  String get pleaseInsertName;

  /// No description provided for @pleaseInsertSurname.
  ///
  /// In en, this message translates to:
  /// **'Please insert a surname'**
  String get pleaseInsertSurname;

  /// No description provided for @pleaseInsertPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please insert a phone number'**
  String get pleaseInsertPhoneNumber;

  /// No description provided for @pleaseInsertEmail.
  ///
  /// In en, this message translates to:
  /// **'Please insert an email'**
  String get pleaseInsertEmail;

  /// No description provided for @pleaseInsertAddress.
  ///
  /// In en, this message translates to:
  /// **'Please insert an address'**
  String get pleaseInsertAddress;

  /// No description provided for @removeClientConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove this client?'**
  String get removeClientConfirmation;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @noAppointmentsMessage.
  ///
  /// In en, this message translates to:
  /// **'No appointments found. Add a new one!'**
  String get noAppointmentsMessage;

  /// No description provided for @servicesName.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesName;

  /// No description provided for @noServicesMessage.
  ///
  /// In en, this message translates to:
  /// **'No services found. Add a new one!'**
  String get noServicesMessage;

  /// No description provided for @newServiceNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'New Service'**
  String get newServiceNamePlaceholder;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @pleaseInsertPrice.
  ///
  /// In en, this message translates to:
  /// **'Please insert a price'**
  String get pleaseInsertPrice;

  /// No description provided for @removeServiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove this service?'**
  String get removeServiceConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
