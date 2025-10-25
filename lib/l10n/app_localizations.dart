import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

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
    Locale('hi'),
    Locale('ta'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Bhoomi'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @yourEcoJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Eco Journey'**
  String get yourEcoJourney;

  /// No description provided for @ecoScore.
  ///
  /// In en, this message translates to:
  /// **'Eco-Score'**
  String get ecoScore;

  /// No description provided for @outOf100.
  ///
  /// In en, this message translates to:
  /// **'out of 100'**
  String get outOf100;

  /// No description provided for @takeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get takeAction;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @todaysTip.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tip 💡'**
  String get todaysTip;

  /// No description provided for @swipeForMore.
  ///
  /// In en, this message translates to:
  /// **'Swipe for more'**
  String get swipeForMore;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @treesNeeded.
  ///
  /// In en, this message translates to:
  /// **'Trees Needed'**
  String get treesNeeded;

  /// No description provided for @toOffset.
  ///
  /// In en, this message translates to:
  /// **'to offset'**
  String get toOffset;

  /// No description provided for @co2PerMonth.
  ///
  /// In en, this message translates to:
  /// **'CO₂/month'**
  String get co2PerMonth;

  /// No description provided for @carbonCalculator.
  ///
  /// In en, this message translates to:
  /// **'Carbon Calculator'**
  String get carbonCalculator;

  /// No description provided for @letsCalculate.
  ///
  /// In en, this message translates to:
  /// **'Let\'s calculate your carbon footprint'**
  String get letsCalculate;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation 🚗'**
  String get transportation;

  /// No description provided for @twoWheeler.
  ///
  /// In en, this message translates to:
  /// **'Two-Wheeler'**
  String get twoWheeler;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @publicTransport.
  ///
  /// In en, this message translates to:
  /// **'Public Transport'**
  String get publicTransport;

  /// No description provided for @kmPerMonth.
  ///
  /// In en, this message translates to:
  /// **'km/month'**
  String get kmPerMonth;

  /// No description provided for @foodHabits.
  ///
  /// In en, this message translates to:
  /// **'Food Habits 🍽️'**
  String get foodHabits;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @nonVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Non-Vegetarian'**
  String get nonVegetarian;

  /// No description provided for @mealsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'meals/week'**
  String get mealsPerWeek;

  /// No description provided for @energyUsage.
  ///
  /// In en, this message translates to:
  /// **'Energy Usage ⚡'**
  String get energyUsage;

  /// No description provided for @selectYourState.
  ///
  /// In en, this message translates to:
  /// **'Select your state'**
  String get selectYourState;

  /// No description provided for @electricityUnits.
  ///
  /// In en, this message translates to:
  /// **'Electricity Units'**
  String get electricityUnits;

  /// No description provided for @unitsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'units/month'**
  String get unitsPerMonth;

  /// No description provided for @calculateFootprint.
  ///
  /// In en, this message translates to:
  /// **'Calculate Footprint'**
  String get calculateFootprint;

  /// No description provided for @viewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get viewResults;

  /// No description provided for @yourCarbonFootprint.
  ///
  /// In en, this message translates to:
  /// **'Your Carbon Footprint'**
  String get yourCarbonFootprint;

  /// No description provided for @totalEmissions.
  ///
  /// In en, this message translates to:
  /// **'Total Emissions'**
  String get totalEmissions;

  /// No description provided for @kgPerYear.
  ///
  /// In en, this message translates to:
  /// **'kg/year'**
  String get kgPerYear;

  /// No description provided for @aboveAverage.
  ///
  /// In en, this message translates to:
  /// **'Above Average'**
  String get aboveAverage;

  /// No description provided for @belowAverage.
  ///
  /// In en, this message translates to:
  /// **'Below Average'**
  String get belowAverage;

  /// Comparison text
  ///
  /// In en, this message translates to:
  /// **'Your emissions are {percent}% {comparison} than average Indian'**
  String emissionsCompare(String percent, String comparison);

  /// No description provided for @higher.
  ///
  /// In en, this message translates to:
  /// **'higher'**
  String get higher;

  /// No description provided for @lower.
  ///
  /// In en, this message translates to:
  /// **'lower'**
  String get lower;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @emissionsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Emissions Breakdown'**
  String get emissionsBreakdown;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @enterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated!'**
  String get profileUpdated;

  /// No description provided for @yourImpact.
  ///
  /// In en, this message translates to:
  /// **'Your Impact'**
  String get yourImpact;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @joinBhoomi.
  ///
  /// In en, this message translates to:
  /// **'Join Bhoomi and start your journey towards a sustainable lifestyle'**
  String get joinBhoomi;

  /// No description provided for @savesMonthly.
  ///
  /// In en, this message translates to:
  /// **'Saves: ₹200-300/month 💰'**
  String get savesMonthly;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get tamil;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed!'**
  String get languageChanged;

  /// No description provided for @tipCycling.
  ///
  /// In en, this message translates to:
  /// **'🚲 Consider cycling or walking for short distances to reduce your transport emissions by 30%'**
  String get tipCycling;

  /// No description provided for @tipPublicTransport.
  ///
  /// In en, this message translates to:
  /// **'🚌 Use public transport 2-3 times a week to save ₹500/month and reduce CO2'**
  String get tipPublicTransport;

  /// No description provided for @tipCarpooling.
  ///
  /// In en, this message translates to:
  /// **'🚗 Carpooling can reduce your transport emissions by 25% and save fuel costs'**
  String get tipCarpooling;

  /// No description provided for @tipMeatlessMonday.
  ///
  /// In en, this message translates to:
  /// **'🥗 Try Meatless Mondays! Reducing meat by 2 meals/week can save 30kg CO2/month'**
  String get tipMeatlessMonday;

  /// No description provided for @tipLocalProduce.
  ///
  /// In en, this message translates to:
  /// **'🌱 Choose local and seasonal produce to reduce food emissions by 15%'**
  String get tipLocalProduce;

  /// No description provided for @tipPlantBased.
  ///
  /// In en, this message translates to:
  /// **'🥬 Great food choices! Try adding one more plant-based meal per week'**
  String get tipPlantBased;

  /// No description provided for @tipLED.
  ///
  /// In en, this message translates to:
  /// **'💡 Switch to LED bulbs and save ₹800/year on electricity bills'**
  String get tipLED;

  /// No description provided for @tipAC.
  ///
  /// In en, this message translates to:
  /// **'❄️ Set AC temperature to 24°C to reduce energy consumption by 20%'**
  String get tipAC;

  /// No description provided for @tipUnplug.
  ///
  /// In en, this message translates to:
  /// **'🔌 Unplug devices when not in use - phantom power costs ₹500/year'**
  String get tipUnplug;

  /// No description provided for @tipSolar.
  ///
  /// In en, this message translates to:
  /// **'☀️ Consider solar panels for long-term savings and clean energy'**
  String get tipSolar;

  /// No description provided for @tipAmazing.
  ///
  /// In en, this message translates to:
  /// **'🌟 Amazing! You\'re below average Indian carbon footprint. Keep it up!'**
  String get tipAmazing;
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
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
