class TransportationData {
  final String vehicleType;
  final double weeklyFuelSpend; // in INR
  final double weeklyDistance; // in km
  final int autoBusFrequency; // times per week
  
  TransportationData({
    required this.vehicleType,
    this.weeklyFuelSpend = 0,
    this.weeklyDistance = 0,
    this.autoBusFrequency = 0,
  });
  
  // Carbon emission factors (kg CO2 per km)
  static const Map<String, double> emissionFactors = {
    'two_wheeler': 0.08, // 80g CO2/km
    'car_petrol': 0.18, // 180g CO2/km
    'car_diesel': 0.17, // 170g CO2/km
    'auto': 0.12, // 120g CO2/km
    'bus': 0.04, // 40g CO2/km per passenger
    'electric_vehicle': 0.04, // 40g CO2/km (considering Indian grid mix)
    'bicycle': 0.0,
    'walk': 0.0,
  };
  
  // Average fuel prices in India (INR per liter)
  static const double petrolPrice = 100.0;
  static const double dieselPrice = 90.0;
  
  // Average mileage (km per liter)
  static const Map<String, double> averageMileage = {
    'two_wheeler': 40.0,
    'car_petrol': 15.0,
    'car_diesel': 18.0,
  };
  
  double calculateWeeklyCO2() {
    double co2 = 0;
    
    // Calculate from fuel spend
    if (weeklyFuelSpend > 0) {
      double fuelPrice = vehicleType.contains('diesel') ? dieselPrice : petrolPrice;
      double litersConsumed = weeklyFuelSpend / fuelPrice;
      double distance = litersConsumed * (averageMileage[vehicleType] ?? 15.0);
      co2 += distance * (emissionFactors[vehicleType] ?? 0.15);
    }
    
    // Calculate from distance
    if (weeklyDistance > 0) {
      co2 += weeklyDistance * (emissionFactors[vehicleType] ?? 0.15);
    }
    
    // Calculate from auto/bus usage
    if (autoBusFrequency > 0) {
      double avgDistancePerTrip = 10.0; // Average trip distance in km
      co2 += autoBusFrequency * avgDistancePerTrip * (emissionFactors['auto'] ?? 0.12);
    }
    
    return co2;
  }
  
  double calculateMonthlyCO2() {
    return calculateWeeklyCO2() * 4.33; // Average weeks per month
  }
  
  double calculateYearlyCO2() {
    return calculateWeeklyCO2() * 52; // Weeks per year
  }
}

class FoodData {
  final int nonVegMealsPerWeek;
  final int dairyFreeDaysPerWeek;
  final int localFoodDaysPerWeek;
  
  FoodData({
    required this.nonVegMealsPerWeek,
    this.dairyFreeDaysPerWeek = 0,
    this.localFoodDaysPerWeek = 0,
  });
  
  // Carbon emission factors (kg CO2 per meal/day)
  static const double nonVegMealEmission = 7.2; // kg CO2 per meal
  static const double vegMealEmission = 2.0; // kg CO2 per meal
  static const double dairyDayEmission = 1.5; // kg CO2 per day with dairy
  static const double localFoodBonus = -0.5; // kg CO2 saved per day
  
  double calculateWeeklyCO2() {
    double co2 = 0;
    
    // Non-veg meals
    co2 += nonVegMealsPerWeek * nonVegMealEmission;
    
    // Vegetarian meals (assuming 21 meals per week - 3 per day)
    int vegMeals = 21 - nonVegMealsPerWeek;
    co2 += vegMeals * vegMealEmission;
    
    // Dairy consumption
    int dairyDays = 7 - dairyFreeDaysPerWeek;
    co2 += dairyDays * dairyDayEmission;
    
    // Local food bonus
    co2 += localFoodDaysPerWeek * localFoodBonus;
    
    return co2.clamp(0, double.infinity); // Ensure non-negative
  }
  
  double calculateMonthlyCO2() {
    return calculateWeeklyCO2() * 4.33;
  }
  
  double calculateYearlyCO2() {
    return calculateWeeklyCO2() * 52;
  }
}

class EnergyData {
  final double monthlyElectricityUnits; // in kWh
  final String state; // Indian state for grid factor
  final Map<String, double> applianceUsage; // appliance type -> hours per day
  
  EnergyData({
    required this.monthlyElectricityUnits,
    required this.state,
    this.applianceUsage = const {},
  });
  
  // Grid emission factors by state (kg CO2 per kWh)
  // Based on state power generation mix
  static const Map<String, double> stateGridFactors = {
    'Maharashtra': 0.82,
    'Delhi': 0.70,
    'Karnataka': 0.75,
    'Tamil Nadu': 0.68,
    'Gujarat': 0.85,
    'Uttar Pradesh': 0.80,
    'West Bengal': 0.92,
    'Rajasthan': 0.78,
    'Kerala': 0.55, // High hydro power
    'Himachal Pradesh': 0.30, // Mostly hydro
    'Punjab': 0.75,
    'Haryana': 0.78,
    'Bihar': 0.88,
    'Madhya Pradesh': 0.83,
    'Andhra Pradesh': 0.77,
    'Telangana': 0.79,
    'Odisha': 0.90,
    'Other': 0.80, // National average
  };
  
  // Appliance power ratings (kW)
  static const Map<String, double> appliancePowerRatings = {
    'ac_regular': 1.5,
    'ac_inverter': 1.0,
    'refrigerator': 0.15,
    'washing_machine': 0.5,
    'water_heater': 2.0,
    'tv': 0.1,
    'fan': 0.075,
    'lights_led': 0.01,
    'lights_cfl': 0.015,
    'lights_incandescent': 0.06,
  };
  
  double calculateMonthlyCO2() {
    double gridFactor = stateGridFactors[state] ?? 0.80;
    double co2 = monthlyElectricityUnits * gridFactor;
    
    return co2;
  }
  
  double calculateMonthlyCO2FromAppliances() {
    double totalKWh = 0;
    
    applianceUsage.forEach((appliance, hoursPerDay) {
      double power = appliancePowerRatings[appliance] ?? 0.5;
      double dailyKWh = power * hoursPerDay;
      double monthlyKWh = dailyKWh * 30;
      totalKWh += monthlyKWh;
    });
    
    double gridFactor = stateGridFactors[state] ?? 0.80;
    return totalKWh * gridFactor;
  }
  
  double calculateYearlyCO2() {
    return calculateMonthlyCO2() * 12;
  }
}

class CarbonFootprint {
  final TransportationData transportation;
  final FoodData food;
  final EnergyData energy;
  
  CarbonFootprint({
    required this.transportation,
    required this.food,
    required this.energy,
  });
  
  double getTotalMonthlyCO2() {
    return transportation.calculateMonthlyCO2() +
           food.calculateMonthlyCO2() +
           energy.calculateMonthlyCO2();
  }
  
  double getTotalYearlyCO2() {
    return transportation.calculateYearlyCO2() +
           food.calculateYearlyCO2() +
           energy.calculateYearlyCO2();
  }
  
  Map<String, double> getBreakdown() {
    return {
      'transportation': transportation.calculateMonthlyCO2(),
      'food': food.calculateMonthlyCO2(),
      'energy': energy.calculateMonthlyCO2(),
    };
  }
  
  // Calculate Eco-Score (0-100)
  // Lower emissions = higher score
  // Average Indian carbon footprint: ~1.9 tons CO2/year
  double calculateEcoScore() {
    double yearlyEmissions = getTotalYearlyCO2();
    double avgIndianEmissions = 1900.0; // kg
    
    // Score calculation: 100 - (user emissions / avg emissions * 50)
    // If user is at average: 100 - 50 = 50
    // If user is at 0: 100
    // If user is at 2x average: 0
    double score = 100 - ((yearlyEmissions / avgIndianEmissions) * 50);
    return score.clamp(0, 100);
  }
  
  String getEcoLevel() {
    double score = calculateEcoScore();
    if (score >= 80) return 'Eco Champion';
    if (score >= 60) return 'Green Warrior';
    if (score >= 40) return 'Earth Friend';
    if (score >= 20) return 'Climate Learner';
    return 'Getting Started';
  }
  
  // Get personalized recommendations based on carbon footprint
  List<String> getRecommendations() {
    List<String> recommendations = [];
    Map<String, double> breakdown = getBreakdown();
    
    // Transportation recommendations
    double transportCO2 = breakdown['transportation']!;
    if (transportCO2 > 150) {
      recommendations.add('🚲 Consider cycling or walking for short distances to reduce your transport emissions by 30%');
      recommendations.add('🚌 Use public transport 2-3 times a week to save ₹500/month and reduce CO2');
    } else if (transportCO2 > 80) {
      recommendations.add('🚗 Carpooling can reduce your transport emissions by 25% and save fuel costs');
    }
    
    // Food recommendations
    double foodCO2 = breakdown['food']!;
    if (foodCO2 > 250) {
      recommendations.add('🥗 Try Meatless Mondays! Reducing meat by 2 meals/week can save 30kg CO2/month');
      recommendations.add('🌱 Choose local and seasonal produce to reduce food emissions by 15%');
    } else if (foodCO2 > 150) {
      recommendations.add('🥬 Great food choices! Try adding one more plant-based meal per week');
    }
    
    // Energy recommendations
    double energyCO2 = breakdown['energy']!;
    if (energyCO2 > 200) {
      recommendations.add('💡 Switch to LED bulbs and save ₹800/year on electricity bills');
      recommendations.add('❄️ Set AC temperature to 24°C to reduce energy consumption by 20%');
      recommendations.add('🔌 Unplug devices when not in use - phantom power costs ₹500/year');
    } else if (energyCO2 > 120) {
      recommendations.add('☀️ Consider solar panels for long-term savings and clean energy');
    }
    
    // Overall recommendations
    if (getTotalMonthlyCO2() < 300) {
      recommendations.add('🌟 Amazing! You\'re below average Indian carbon footprint. Keep it up!');
    }
    
    return recommendations;
  }
  
  // Get comparison with average Indian
  Map<String, dynamic> getComparison() {
    double yearlyEmissions = getTotalYearlyCO2();
    double avgIndianEmissions = 1900.0; // kg CO2/year
    double difference = yearlyEmissions - avgIndianEmissions;
    double percentDiff = (difference / avgIndianEmissions) * 100;
    
    return {
      'userEmissions': yearlyEmissions,
      'avgEmissions': avgIndianEmissions,
      'difference': difference,
      'percentDiff': percentDiff,
      'isAboveAverage': difference > 0,
    };
  }
  
  // Calculate trees needed to offset emissions
  int getTreesNeeded() {
    // One tree absorbs approximately 20kg CO2 per year
    double yearlyCO2 = getTotalYearlyCO2();
    return (yearlyCO2 / 20).ceil();
  }
  
  // Calculate equivalent activities
  Map<String, double> getEquivalentActivities() {
    double monthlyCO2 = getTotalMonthlyCO2();
    
    return {
      'smartphone_charges': monthlyCO2 / 0.008, // kg CO2 per charge
      'km_driven': monthlyCO2 / 0.18, // Average car
      'meals_cooked': monthlyCO2 / 2.5, // kg CO2 per meal
      'plastic_bottles': monthlyCO2 / 0.082, // kg CO2 per bottle
    };
  }
}
