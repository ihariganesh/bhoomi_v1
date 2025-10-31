/// AI-Driven Recommendation Engine
/// Provides personalized eco-action suggestions based on user habits,
/// location, festivals, and environmental factors
class RecommendationEngine {
  /// Generate personalized recommendations
  static List<EcoRecommendation> generateRecommendations({
    required String userCity,
    required double carbonFootprint,
    required Map<String, dynamic> userHabits,
    DateTime? currentDate,
  }) {
    final date = currentDate ?? DateTime.now();
    final recommendations = <EcoRecommendation>[];

    // Festival-based recommendations
    recommendations.addAll(_getFestivalRecommendations(date, userCity));

    // Pollution-based recommendations
    recommendations.addAll(_getPollutionBasedRecommendations(userCity, date));

    // Habit-based recommendations
    recommendations.addAll(
      _getHabitBasedRecommendations(userHabits, carbonFootprint),
    );

    // Seasonal recommendations
    recommendations.addAll(_getSeasonalRecommendations(date, userCity));

    // Sort by priority and relevance
    recommendations.sort((a, b) => b.priority.compareTo(a.priority));

    return recommendations.take(10).toList();
  }

  /// Festival-specific recommendations
  static List<EcoRecommendation> _getFestivalRecommendations(
    DateTime date,
    String city,
  ) {
    final recommendations = <EcoRecommendation>[];
    final month = date.month;

    // Diwali (October-November)
    if (month == 10 || month == 11) {
      recommendations.add(
        EcoRecommendation(
          id: 'diwali_crackers',
          title: 'Choose Green Diwali',
          titleHi: 'हरित दिवाली चुनें',
          description:
              'Avoid firecrackers and opt for diyas and LED lights. Save ₹2000 and reduce 50kg CO₂.',
          descriptionHi:
              'पटाखों से बचें और दीये तथा LED लाइट का उपयोग करें। ₹2000 बचाएं और 50 किलो CO₂ कम करें।',
          category: RecommendationType.festival,
          priority: 100,
          potentialSavings: 2000,
          co2Reduction: 50.0,
          actionSteps: [
            'Use traditional clay diyas',
            'Decorate with LED lights',
            'Gift plants instead of sweets',
            'Organize community rangoli competition',
          ],
          festivalName: 'Diwali',
          validUntil: DateTime(date.year, 11, 30),
        ),
      );
    }

    // Holi (February-March)
    if (month == 2 || month == 3) {
      recommendations.add(
        EcoRecommendation(
          id: 'holi_colors',
          title: 'Play with Natural Colors',
          titleHi: 'प्राकृतिक रंगों से खेलें',
          description:
              'Use organic, plant-based colors. Protect your skin and save water.',
          descriptionHi:
              'जैविक, पौधे आधारित रंगों का उपयोग करें। अपनी त्वचा की रक्षा करें और पानी बचाएं।',
          category: RecommendationType.festival,
          priority: 95,
          potentialSavings: 500,
          co2Reduction: 10.0,
          actionSteps: [
            'Make colors from turmeric, beetroot',
            'Limit water use during play',
            'Avoid chemical colors',
            'Clean up after celebrations',
          ],
          festivalName: 'Holi',
          validUntil: DateTime(date.year, 3, 31),
        ),
      );
    }

    // Pongal (January)
    if (month == 1 && city.toLowerCase().contains('chennai') ||
        city.toLowerCase().contains('tamil') ||
        city.toLowerCase().contains('coimbatore')) {
      recommendations.add(
        EcoRecommendation(
          id: 'pongal_eco',
          title: 'Celebrate Eco-Friendly Pongal',
          titleHi: 'पर्यावरण के अनुकूल पोंगल मनाएं',
          description: 'Use clay pots, avoid plastic, and donate surplus food.',
          descriptionHi:
              'मिट्टी के बर्तन का उपयोग करें, प्लास्टिक से बचें और अतिरिक्त भोजन दान करें।',
          category: RecommendationType.festival,
          priority: 90,
          potentialSavings: 300,
          co2Reduction: 8.0,
          actionSteps: [
            'Cook in clay pots',
            'Avoid plastic decorations',
            'Share surplus with community',
            'Use organic produce',
          ],
          festivalName: 'Pongal',
          validUntil: DateTime(date.year, 1, 20),
        ),
      );
    }

    return recommendations;
  }

  /// Pollution-based recommendations
  static List<EcoRecommendation> _getPollutionBasedRecommendations(
    String city,
    DateTime date,
  ) {
    final recommendations = <EcoRecommendation>[];

    // High pollution cities
    final highPollutionCities = [
      'delhi',
      'mumbai',
      'kolkata',
      'bangalore',
      'chennai',
    ];

    if (highPollutionCities.any((c) => city.toLowerCase().contains(c))) {
      // Winter pollution
      if (date.month >= 11 || date.month <= 2) {
        recommendations.add(
          EcoRecommendation(
            id: 'winter_pollution',
            title: 'Combat Winter Air Pollution',
            titleHi: 'शीतकालीन वायु प्रदूषण से लड़ें',
            description:
                'Use public transport and plant indoor air-purifying plants.',
            descriptionHi:
                'सार्वजनिक परिवहन का उपयोग करें और इनडोर वायु शुद्ध करने वाले पौधे लगाएं।',
            category: RecommendationType.pollution,
            priority: 85,
            potentialSavings: 800,
            co2Reduction: 25.0,
            actionSteps: [
              'Use metro/bus for daily commute',
              'Plant money plant, spider plant',
              'Avoid burning waste',
              'Carpool with colleagues',
            ],
            validUntil: DateTime(date.year, 3, 1),
          ),
        );
      }
    }

    return recommendations;
  }

  /// Habit-based recommendations
  static List<EcoRecommendation> _getHabitBasedRecommendations(
    Map<String, dynamic> habits,
    double carbonFootprint,
  ) {
    final recommendations = <EcoRecommendation>[];

    // High carbon footprint
    if (carbonFootprint > 2.0) {
      recommendations.add(
        EcoRecommendation(
          id: 'reduce_footprint',
          title: 'Reduce Your Carbon Footprint',
          titleHi: 'अपने कार्बन फुटप्रिंट को कम करें',
          description:
              'Your footprint is above average. Try these simple changes.',
          descriptionHi:
              'आपका फुटप्रिंट औसत से अधिक है। इन सरल बदलावों को आज़माएं।',
          category: RecommendationType.personal,
          priority: 80,
          potentialSavings: 1500,
          co2Reduction: 40.0,
          actionSteps: [
            'Reduce car usage by 30%',
            'Have 2 meatless days per week',
            'Switch to LED bulbs',
            'Use solar water heater',
          ],
        ),
      );
    }

    return recommendations;
  }

  /// Seasonal recommendations
  static List<EcoRecommendation> _getSeasonalRecommendations(
    DateTime date,
    String city,
  ) {
    final recommendations = <EcoRecommendation>[];
    final month = date.month;

    // Summer (April-June)
    if (month >= 4 && month <= 6) {
      recommendations.add(
        EcoRecommendation(
          id: 'summer_energy',
          title: 'Save Energy This Summer',
          titleHi: 'इस गर्मी में ऊर्जा बचाएं',
          description:
              'Use AC efficiently and save water. Reduce electricity bill by ₹1200/month.',
          descriptionHi:
              'AC का कुशलता से उपयोग करें और पानी बचाएं। बिजली का बिल ₹1200/माह कम करें।',
          category: RecommendationType.seasonal,
          priority: 75,
          potentialSavings: 1200,
          co2Reduction: 30.0,
          actionSteps: [
            'Set AC to 24°C',
            'Use ceiling fan with AC',
            'Close curtains during daytime',
            'Harvest rainwater if possible',
          ],
        ),
      );
    }

    // Monsoon (July-September)
    if (month >= 7 && month <= 9) {
      recommendations.add(
        EcoRecommendation(
          id: 'monsoon_water',
          title: 'Harvest Rainwater',
          titleHi: 'वर्षा जल संचयन करें',
          description:
              'Set up simple rainwater harvesting. Save ₹500 on water bills.',
          descriptionHi:
              'सरल वर्षा जल संचयन स्थापित करें। पानी के बिल पर ₹500 बचाएं।',
          category: RecommendationType.seasonal,
          priority: 70,
          potentialSavings: 500,
          co2Reduction: 15.0,
          actionSteps: [
            'Clean roof gutters',
            'Direct water to plants',
            'Store in clean containers',
            'Use for non-drinking purposes',
          ],
        ),
      );
    }

    return recommendations;
  }
}

/// Eco-Action Recommendation Model
class EcoRecommendation {
  final String id;
  final String title;
  final String titleHi;
  final String description;
  final String descriptionHi;
  final RecommendationType category;
  final int priority; // 0-100, higher is more important
  final double potentialSavings; // in Rupees
  final double co2Reduction; // in kg
  final List<String> actionSteps;
  final String? festivalName;
  final DateTime? validUntil;
  final String? imageUrl;
  final bool isCompleted;

  EcoRecommendation({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.description,
    required this.descriptionHi,
    required this.category,
    required this.priority,
    required this.potentialSavings,
    required this.co2Reduction,
    required this.actionSteps,
    this.festivalName,
    this.validUntil,
    this.imageUrl,
    this.isCompleted = false,
  });

  EcoRecommendation copyWith({
    String? id,
    String? title,
    String? titleHi,
    String? description,
    String? descriptionHi,
    RecommendationType? category,
    int? priority,
    double? potentialSavings,
    double? co2Reduction,
    List<String>? actionSteps,
    String? festivalName,
    DateTime? validUntil,
    String? imageUrl,
    bool? isCompleted,
  }) {
    return EcoRecommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      titleHi: titleHi ?? this.titleHi,
      description: description ?? this.description,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      potentialSavings: potentialSavings ?? this.potentialSavings,
      co2Reduction: co2Reduction ?? this.co2Reduction,
      actionSteps: actionSteps ?? this.actionSteps,
      festivalName: festivalName ?? this.festivalName,
      validUntil: validUntil ?? this.validUntil,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHi': titleHi,
      'description': description,
      'descriptionHi': descriptionHi,
      'category': category.toString(),
      'priority': priority,
      'potentialSavings': potentialSavings,
      'co2Reduction': co2Reduction,
      'actionSteps': actionSteps,
      'festivalName': festivalName,
      'validUntil': validUntil?.toIso8601String(),
      'imageUrl': imageUrl,
      'isCompleted': isCompleted,
    };
  }

  factory EcoRecommendation.fromJson(Map<String, dynamic> json) {
    return EcoRecommendation(
      id: json['id'],
      title: json['title'],
      titleHi: json['titleHi'] ?? json['title'],
      description: json['description'],
      descriptionHi: json['descriptionHi'] ?? json['description'],
      category: RecommendationType.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => RecommendationType.personal,
      ),
      priority: json['priority'],
      potentialSavings: json['potentialSavings'].toDouble(),
      co2Reduction: json['co2Reduction'].toDouble(),
      actionSteps: List<String>.from(json['actionSteps']),
      festivalName: json['festivalName'],
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      imageUrl: json['imageUrl'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

enum RecommendationType {
  festival,
  pollution,
  seasonal,
  personal,
  community,
  transport,
  energy,
  food,
}
