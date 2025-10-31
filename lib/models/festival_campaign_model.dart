/// Festival Campaign System
/// Special eco-challenges during major Indian festivals

class FestivalCampaign {
  final String id;
  final String name;
  final String nameHi;
  final String description;
  final String descriptionHi;
  final FestivalType festival;
  final DateTime startDate;
  final DateTime endDate;
  final List<FestivalChallenge> challenges;
  final String badgeIcon;
  final int totalParticipants;
  final double totalCO2Saved;

  FestivalCampaign({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.description,
    required this.descriptionHi,
    required this.festival,
    required this.startDate,
    required this.endDate,
    required this.challenges,
    required this.badgeIcon,
    this.totalParticipants = 0,
    this.totalCO2Saved = 0,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming {
    return DateTime.now().isBefore(startDate);
  }

  bool get isCompleted {
    return DateTime.now().isAfter(endDate);
  }

  /// Get all active festival campaigns
  static List<FestivalCampaign> getActiveCampaigns() {
    final now = DateTime.now();
    final campaigns = <FestivalCampaign>[];

    // Diwali Campaign
    if (now.month == 10 || now.month == 11) {
      campaigns.add(
        FestivalCampaign(
          id: 'diwali_2025',
          name: 'Green Diwali Challenge',
          nameHi: 'हरित दिवाली चुनौती',
          description:
              'Celebrate an eco-friendly Diwali. Avoid crackers, use diyas, reduce waste.',
          descriptionHi:
              'पर्यावरण के अनुकूल दिवाली मनाएं। पटाखों से बचें, दीये का उपयोग करें, कचरा कम करें।',
          festival: FestivalType.diwali,
          startDate: DateTime(now.year, 10, 20),
          endDate: DateTime(now.year, 11, 15),
          badgeIcon: '🪔',
          challenges: [
            FestivalChallenge(
              id: 'diwali_no_crackers',
              title: 'No Crackers Pledge',
              titleHi: 'पटाखे नहीं संकल्प',
              description: 'Pledge to not burst any crackers this Diwali',
              descriptionHi: 'इस दिवाली कोई पटाखे न फोड़ने का संकल्प लें',
              points: 100,
              co2Saved: 50.0,
              icon: '🧨',
            ),
            FestivalChallenge(
              id: 'diwali_led_lights',
              title: 'Use LED Lights Only',
              titleHi: 'केवल LED लाइट का उपयोग करें',
              description: 'Decorate with energy-efficient LED lights',
              descriptionHi: 'ऊर्जा-कुशल LED लाइटों से सजाएं',
              points: 50,
              co2Saved: 15.0,
              icon: '💡',
            ),
            FestivalChallenge(
              id: 'diwali_clay_diyas',
              title: 'Light Clay Diyas',
              titleHi: 'मिट्टी के दीये जलाएं',
              description:
                  'Use traditional clay diyas instead of electric lights',
              descriptionHi:
                  'बिजली की रोशनी के बजाय पारंपरिक मिट्टी के दीये का उपयोग करें',
              points: 75,
              co2Saved: 20.0,
              icon: '🪔',
            ),
            FestivalChallenge(
              id: 'diwali_plant_gifts',
              title: 'Gift Plants',
              titleHi: 'पौधे उपहार दें',
              description: 'Gift plants instead of sweets or plastic items',
              descriptionHi:
                  'मिठाई या प्लास्टिक की चीजों के बजाय पौधे उपहार में दें',
              points: 60,
              co2Saved: 10.0,
              icon: '🌱',
            ),
          ],
        ),
      );
    }

    // Holi Campaign
    if (now.month == 2 || now.month == 3) {
      campaigns.add(
        FestivalCampaign(
          id: 'holi_2025',
          name: 'Natural Colors Holi',
          nameHi: 'प्राकृतिक रंग होली',
          description:
              'Play Holi with natural, eco-friendly colors and save water.',
          descriptionHi:
              'प्राकृतिक, पर्यावरण के अनुकूल रंगों से होली खेलें और पानी बचाएं।',
          festival: FestivalType.holi,
          startDate: DateTime(now.year, 2, 20),
          endDate: DateTime(now.year, 3, 20),
          badgeIcon: '🎨',
          challenges: [
            FestivalChallenge(
              id: 'holi_natural_colors',
              title: 'Use Natural Colors',
              titleHi: 'प्राकृतिक रंगों का उपयोग करें',
              description:
                  'Make or buy colors from turmeric, beetroot, flowers',
              descriptionHi: 'हल्दी, चुकंदर, फूलों से रंग बनाएं या खरीदें',
              points: 80,
              co2Saved: 12.0,
              icon: '🌺',
            ),
            FestivalChallenge(
              id: 'holi_water_save',
              title: 'Water Conservation',
              titleHi: 'जल संरक्षण',
              description: 'Limit water use during Holi celebrations',
              descriptionHi: 'होली समारोह के दौरान पानी का उपयोग सीमित करें',
              points: 70,
              co2Saved: 8.0,
              icon: '💧',
            ),
            FestivalChallenge(
              id: 'holi_cleanup',
              title: 'Post-Holi Cleanup',
              titleHi: 'होली के बाद सफाई',
              description: 'Organize community cleanup after Holi',
              descriptionHi: 'होली के बाद सामुदायिक सफाई आयोजित करें',
              points: 100,
              co2Saved: 15.0,
              icon: '🧹',
            ),
          ],
        ),
      );
    }

    // Pongal Campaign
    if (now.month == 1) {
      campaigns.add(
        FestivalCampaign(
          id: 'pongal_2025',
          name: 'Eco-Friendly Pongal',
          nameHi: 'पर्यावरण के अनुकूल पोंगल',
          description: 'Celebrate harvest festival with sustainable practices.',
          descriptionHi: 'स्थायी प्रथाओं के साथ फसल उत्सव मनाएं।',
          festival: FestivalType.pongal,
          startDate: DateTime(now.year, 1, 10),
          endDate: DateTime(now.year, 1, 18),
          badgeIcon: '🍚',
          challenges: [
            FestivalChallenge(
              id: 'pongal_clay_pots',
              title: 'Cook in Clay Pots',
              titleHi: 'मिट्टी के बर्तन में पकाएं',
              description: 'Use traditional clay pots for cooking Pongal',
              descriptionHi:
                  'पोंगल पकाने के लिए पारंपरिक मिट्टी के बर्तन का उपयोग करें',
              points: 60,
              co2Saved: 8.0,
              icon: '🏺',
            ),
            FestivalChallenge(
              id: 'pongal_local_produce',
              title: 'Use Local Ingredients',
              titleHi: 'स्थानीय सामग्री का उपयोग करें',
              description: 'Source all ingredients from local farmers',
              descriptionHi: 'स्थानीय किसानों से सभी सामग्री प्राप्त करें',
              points: 70,
              co2Saved: 10.0,
              icon: '🌾',
            ),
          ],
        ),
      );
    }

    // Onam Campaign
    if (now.month == 8 || now.month == 9) {
      campaigns.add(
        FestivalCampaign(
          id: 'onam_2025',
          name: 'Green Onam',
          nameHi: 'हरित ओणम',
          description: 'Celebrate Onam with flower carpets and zero waste.',
          descriptionHi: 'फूलों के कालीन और शून्य अपशिष्ट के साथ ओणम मनाएं।',
          festival: FestivalType.onam,
          startDate: DateTime(now.year, 8, 20),
          endDate: DateTime(now.year, 9, 5),
          badgeIcon: '🌺',
          challenges: [
            FestivalChallenge(
              id: 'onam_flower_pookalam',
              title: 'Natural Flower Pookalam',
              titleHi: 'प्राकृतिक फूल पूकलम',
              description: 'Create Pookalam with local, organic flowers',
              descriptionHi: 'स्थानीय, जैविक फूलों से पूकलम बनाएं',
              points: 80,
              co2Saved: 12.0,
              icon: '🌸',
            ),
            FestivalChallenge(
              id: 'onam_banana_leaf',
              title: 'Sadya on Banana Leaf',
              titleHi: 'केले के पत्ते पर सद्या',
              description: 'Serve traditional Sadya on banana leaves',
              descriptionHi: 'केले के पत्तों पर पारंपरिक सद्या परोसें',
              points: 50,
              co2Saved: 5.0,
              icon: '🍌',
            ),
          ],
        ),
      );
    }

    return campaigns.where((c) => c.isActive || c.isUpcoming).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameHi': nameHi,
      'description': description,
      'descriptionHi': descriptionHi,
      'festival': festival.toString(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'challenges': challenges.map((c) => c.toJson()).toList(),
      'badgeIcon': badgeIcon,
      'totalParticipants': totalParticipants,
      'totalCO2Saved': totalCO2Saved,
    };
  }
}

/// Festival Challenge
class FestivalChallenge {
  final String id;
  final String title;
  final String titleHi;
  final String description;
  final String descriptionHi;
  final int points;
  final double co2Saved;
  final String icon;
  final bool isCompleted;
  final DateTime? completedAt;

  FestivalChallenge({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.description,
    required this.descriptionHi,
    required this.points,
    required this.co2Saved,
    required this.icon,
    this.isCompleted = false,
    this.completedAt,
  });

  FestivalChallenge copyWith({
    String? id,
    String? title,
    String? titleHi,
    String? description,
    String? descriptionHi,
    int? points,
    double? co2Saved,
    String? icon,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return FestivalChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      titleHi: titleHi ?? this.titleHi,
      description: description ?? this.description,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      points: points ?? this.points,
      co2Saved: co2Saved ?? this.co2Saved,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleHi': titleHi,
      'description': description,
      'descriptionHi': descriptionHi,
      'points': points,
      'co2Saved': co2Saved,
      'icon': icon,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory FestivalChallenge.fromJson(Map<String, dynamic> json) {
    return FestivalChallenge(
      id: json['id'],
      title: json['title'],
      titleHi: json['titleHi'],
      description: json['description'],
      descriptionHi: json['descriptionHi'],
      points: json['points'],
      co2Saved: json['co2Saved'].toDouble(),
      icon: json['icon'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}

enum FestivalType {
  diwali,
  holi,
  eid,
  christmas,
  pongal,
  onam,
  durga_puja,
  ganesh_chaturthi,
  navratri,
  baisakhi,
}

extension FestivalTypeExtension on FestivalType {
  String get displayName {
    switch (this) {
      case FestivalType.diwali:
        return 'Diwali';
      case FestivalType.holi:
        return 'Holi';
      case FestivalType.eid:
        return 'Eid';
      case FestivalType.christmas:
        return 'Christmas';
      case FestivalType.pongal:
        return 'Pongal';
      case FestivalType.onam:
        return 'Onam';
      case FestivalType.durga_puja:
        return 'Durga Puja';
      case FestivalType.ganesh_chaturthi:
        return 'Ganesh Chaturthi';
      case FestivalType.navratri:
        return 'Navratri';
      case FestivalType.baisakhi:
        return 'Baisakhi';
    }
  }

  String get displayNameHi {
    switch (this) {
      case FestivalType.diwali:
        return 'दिवाली';
      case FestivalType.holi:
        return 'होली';
      case FestivalType.eid:
        return 'ईद';
      case FestivalType.christmas:
        return 'क्रिसमस';
      case FestivalType.pongal:
        return 'पोंगल';
      case FestivalType.onam:
        return 'ओणम';
      case FestivalType.durga_puja:
        return 'दुर्गा पूजा';
      case FestivalType.ganesh_chaturthi:
        return 'गणेश चतुर्थी';
      case FestivalType.navratri:
        return 'नवरात्रि';
      case FestivalType.baisakhi:
        return 'बैसाखी';
    }
  }
}
