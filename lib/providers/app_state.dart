import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/carbon_calculator.dart';

class AppState extends ChangeNotifier {
  // User data
  TransportationData _transportation = TransportationData(vehicleType: 'two_wheeler');
  FoodData _food = FoodData(nonVegMealsPerWeek: 3);
  EnergyData _energy = EnergyData(monthlyElectricityUnits: 200, state: 'Maharashtra');
  
  String _userName = 'User';
  String _userCity = 'Mumbai';
  int _userAge = 0;
  String _userGender = 'Not specified';
  double _ecoScore = 50.0;
  int _streakDays = 0;
  
  // Getters
  TransportationData get transportation => _transportation;
  FoodData get food => _food;
  EnergyData get energy => _energy;
  String get userName => _userName;
  String get userCity => _userCity;
  int get userAge => _userAge;
  String get userGender => _userGender;
  double get ecoScore => _ecoScore;
  int get streakDays => _streakDays;
  
  CarbonFootprint get carbonFootprint => CarbonFootprint(
    transportation: _transportation,
    food: _food,
    energy: _energy,
  );
  
  // Initialize app state
  Future<void> initializeApp() async {
    await loadUserData();
    updateEcoScore();
  }
  
  // Update transportation data
  void updateTransportation(TransportationData data) {
    _transportation = data;
    updateEcoScore();
    saveUserData();
    notifyListeners();
  }
  
  // Update food data
  void updateFood(FoodData data) {
    _food = data;
    updateEcoScore();
    saveUserData();
    notifyListeners();
  }
  
  // Update energy data
  void updateEnergy(EnergyData data) {
    _energy = data;
    updateEcoScore();
    saveUserData();
    notifyListeners();
  }
  
  // Update user profile
  void updateUserProfile(String name, String city, {int? age, String? gender}) {
    _userName = name;
    _userCity = city;
    if (age != null) _userAge = age;
    if (gender != null) _userGender = gender;
    saveUserData();
    notifyListeners();
  }
  
  // Update eco score
  void updateEcoScore() {
    _ecoScore = carbonFootprint.calculateEcoScore();
  }
  
  // Increment streak
  void incrementStreak() {
    _streakDays++;
    saveUserData();
    notifyListeners();
  }
  
  // Save user data to local storage
  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save transportation
    await prefs.setString('vehicleType', _transportation.vehicleType);
    await prefs.setDouble('weeklyFuelSpend', _transportation.weeklyFuelSpend);
    await prefs.setDouble('weeklyDistance', _transportation.weeklyDistance);
    await prefs.setInt('autoBusFrequency', _transportation.autoBusFrequency);
    
    // Save food
    await prefs.setInt('nonVegMealsPerWeek', _food.nonVegMealsPerWeek);
    await prefs.setInt('dairyFreeDaysPerWeek', _food.dairyFreeDaysPerWeek);
    await prefs.setInt('localFoodDaysPerWeek', _food.localFoodDaysPerWeek);
    
    // Save energy
    await prefs.setDouble('monthlyElectricityUnits', _energy.monthlyElectricityUnits);
    await prefs.setString('state', _energy.state);
    
    // Save user profile
    await prefs.setString('userName', _userName);
    await prefs.setString('userCity', _userCity);
    await prefs.setInt('userAge', _userAge);
    await prefs.setString('userGender', _userGender);
    await prefs.setDouble('ecoScore', _ecoScore);
    await prefs.setInt('streakDays', _streakDays);
  }
  
  // Load user data from local storage
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load transportation
    _transportation = TransportationData(
      vehicleType: prefs.getString('vehicleType') ?? 'two_wheeler',
      weeklyFuelSpend: prefs.getDouble('weeklyFuelSpend') ?? 0,
      weeklyDistance: prefs.getDouble('weeklyDistance') ?? 0,
      autoBusFrequency: prefs.getInt('autoBusFrequency') ?? 0,
    );
    
    // Load food
    _food = FoodData(
      nonVegMealsPerWeek: prefs.getInt('nonVegMealsPerWeek') ?? 3,
      dairyFreeDaysPerWeek: prefs.getInt('dairyFreeDaysPerWeek') ?? 0,
      localFoodDaysPerWeek: prefs.getInt('localFoodDaysPerWeek') ?? 0,
    );
    
    // Load energy
    _energy = EnergyData(
      monthlyElectricityUnits: prefs.getDouble('monthlyElectricityUnits') ?? 200,
      state: prefs.getString('state') ?? 'Maharashtra',
    );
    
    // Load user profile
    _userName = prefs.getString('userName') ?? 'User';
    _userCity = prefs.getString('userCity') ?? 'Mumbai';
    _userAge = prefs.getInt('userAge') ?? 0;
    _userGender = prefs.getString('userGender') ?? 'Not specified';
    _ecoScore = prefs.getDouble('ecoScore') ?? 50.0;
    _streakDays = prefs.getInt('streakDays') ?? 0;
    
    notifyListeners();
  }
  
  // Get monthly savings in rupees
  double getMonthlySavings() {
    // Calculate based on average cost savings from reduced emissions
    double co2Reduced = 1900 - carbonFootprint.getTotalYearlyCO2();
    if (co2Reduced < 0) co2Reduced = 0;
    
    // Rough calculation: 1 kg CO2 saved = ₹0.5 saved (fuel/electricity costs)
    return (co2Reduced / 12) * 0.5;
  }
  
  // Get trees equivalent
  int getTreesEquivalent() {
    // 1 tree absorbs ~21 kg CO2 per year
    double yearlyCO2 = carbonFootprint.getTotalYearlyCO2();
    return (yearlyCO2 / 21).round();
  }
}
