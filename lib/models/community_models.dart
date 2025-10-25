class KnowledgeCapsule {
  final String id;
  final String titleEn;
  final String titleHi;
  final String descriptionEn;
  final String descriptionHi;
  final String category; // 'transportation', 'food', 'energy'
  final String impactEn;
  final String impactHi;
  final String videoUrl;
  final String imageUrl;
  final List<String> tags;
  
  KnowledgeCapsule({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.descriptionEn,
    required this.descriptionHi,
    required this.category,
    required this.impactEn,
    required this.impactHi,
    this.videoUrl = '',
    this.imageUrl = '',
    this.tags = const [],
  });
  
  static List<KnowledgeCapsule> getSampleCapsules() {
    return [
      KnowledgeCapsule(
        id: '1',
        titleEn: 'Switch to Inverter AC',
        titleHi: 'इन्वर्टर AC पर स्विच करें',
        descriptionEn: 'Inverter ACs consume 30-50% less electricity compared to regular ACs. They adjust compressor speed based on room temperature, saving energy and money.',
        descriptionHi: 'इन्वर्टर AC नियमित AC की तुलना में 30-50% कम बिजली की खपत करते हैं। वे कमरे के तापमान के आधार पर कंप्रेसर की गति को समायोजित करते हैं।',
        category: 'energy',
        impactEn: 'Saves ₹5,000-8,000 yearly and reduces 150 kg CO₂',
        impactHi: 'सालाना ₹5,000-8,000 की बचत और 150 किलो CO₂ की कमी',
        tags: ['electricity', 'home', 'savings'],
      ),
      KnowledgeCapsule(
        id: '2',
        titleEn: 'Meatless Mondays',
        titleHi: 'मीटलेस मंडे',
        descriptionEn: 'Going vegetarian just one day a week can save 5 kg of CO₂. Traditional Indian vegetarian meals are not only eco-friendly but also nutritious and delicious.',
        descriptionHi: 'सप्ताह में सिर्फ एक दिन शाकाहारी भोजन से 5 किलो CO₂ की बचत हो सकती है। पारंपरिक भारतीय शाकाहारी भोजन न केवल पर्यावरण के अनुकूल है बल्कि पौष्टिक भी है।',
        category: 'food',
        impactEn: 'Saves 20 kg CO₂ monthly from diet',
        impactHi: 'आहार से मासिक 20 किलो CO₂ की बचत',
        tags: ['diet', 'vegetarian', 'health'],
      ),
      KnowledgeCapsule(
        id: '3',
        titleEn: 'Use Public Transport',
        titleHi: 'सार्वजनिक परिवहन का उपयोग करें',
        descriptionEn: 'Taking the bus or metro instead of a personal car can reduce your commute emissions by 75%. Plus, you save on fuel and parking costs!',
        descriptionHi: 'व्यक्तिगत कार के बजाय बस या मेट्रो लेने से आपके यात्रा उत्सर्जन में 75% की कमी हो सकती है। साथ ही, ईंधन और पार्किंग की लागत में बचत!',
        category: 'transportation',
        impactEn: 'Saves ₹3,000-4,000 monthly and 100 kg CO₂',
        impactHi: 'मासिक ₹3,000-4,000 की बचत और 100 किलो CO₂ की कमी',
        tags: ['transport', 'metro', 'bus'],
      ),
      KnowledgeCapsule(
        id: '4',
        titleEn: 'LED Bulbs Save Energy',
        titleHi: 'LED बल्ब ऊर्जा बचाते हैं',
        descriptionEn: 'LED bulbs use 75% less energy than incandescent bulbs and last 25 times longer. Switching all home bulbs to LED can save significant electricity.',
        descriptionHi: 'LED बल्ब गरमागरम बल्बों की तुलना में 75% कम ऊर्जा का उपयोग करते हैं और 25 गुना अधिक समय तक चलते हैं।',
        category: 'energy',
        impactEn: 'Saves ₹1,500 yearly and 50 kg CO₂',
        impactHi: 'सालाना ₹1,500 की बचत और 50 किलो CO₂ की कमी',
        tags: ['electricity', 'lighting', 'savings'],
      ),
      KnowledgeCapsule(
        id: '5',
        titleEn: 'Buy Local Produce',
        titleHi: 'स्थानीय उत्पाद खरीदें',
        descriptionEn: 'Buying fruits and vegetables from local farmers reduces transportation emissions and supports local economy. Fresh and eco-friendly!',
        descriptionHi: 'स्थानीय किसानों से फल और सब्जियां खरीदने से परिवहन उत्सर्जन कम होता है और स्थानीय अर्थव्यवस्था को समर्थन मिलता है।',
        category: 'food',
        impactEn: 'Saves 15 kg CO₂ monthly from food miles',
        impactHi: 'खाद्य परिवहन से मासिक 15 किलो CO₂ की बचत',
        tags: ['local', 'farmers', 'fresh'],
      ),
    ];
  }
}

class LocalEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final String city;
  final DateTime date;
  final String organizer;
  final String category; // 'cleanup', 'workshop', 'plantation', 'awareness'
  final int participants;
  final String imageUrl;
  
  LocalEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.date,
    required this.organizer,
    required this.category,
    this.participants = 0,
    this.imageUrl = '',
  });
  
  static List<LocalEvent> getSampleEvents() {
    return [
      LocalEvent(
        id: '1',
        title: 'Beach Cleanup Drive',
        description: 'Join us for a morning beach cleanup at Juhu Beach. Bring gloves and bags!',
        location: 'Juhu Beach, Mumbai',
        city: 'Mumbai',
        date: DateTime.now().add(const Duration(days: 7)),
        organizer: 'Clean Shores Mumbai',
        category: 'cleanup',
        participants: 45,
      ),
      LocalEvent(
        id: '2',
        title: 'Composting Workshop',
        description: 'Learn how to compost kitchen waste at home. Free workshop for all ages.',
        location: 'Cubbon Park, Bangalore',
        city: 'Bangalore',
        date: DateTime.now().add(const Duration(days: 14)),
        organizer: 'Green Bangalore',
        category: 'workshop',
        participants: 30,
      ),
      LocalEvent(
        id: '3',
        title: 'Tree Plantation Drive',
        description: 'Help us plant 1000 trees this monsoon season!',
        location: 'Aravalli Hills, Delhi',
        city: 'Delhi',
        date: DateTime.now().add(const Duration(days: 21)),
        organizer: 'Delhi Greens',
        category: 'plantation',
        participants: 120,
      ),
    ];
  }
}

class EcoHero {
  final String id;
  final String name;
  final String city;
  final String achievement;
  final String description;
  final String imageUrl;
  final double co2Saved;
  final String category;
  
  EcoHero({
    required this.id,
    required this.name,
    required this.city,
    required this.achievement,
    required this.description,
    this.imageUrl = '',
    this.co2Saved = 0,
    required this.category,
  });
  
  static List<EcoHero> getSampleHeroes() {
    return [
      EcoHero(
        id: '1',
        name: 'Priya Sharma',
        city: 'Mumbai',
        achievement: 'Zero Waste Home',
        description: 'Achieved zero waste lifestyle by composting, recycling, and refusing single-use plastics.',
        co2Saved: 500,
        category: 'waste',
      ),
      EcoHero(
        id: '2',
        name: 'Rajesh Kumar',
        city: 'Bangalore',
        achievement: 'Solar Champion',
        description: 'Installed rooftop solar and powers entire apartment complex with renewable energy.',
        co2Saved: 2500,
        category: 'energy',
      ),
      EcoHero(
        id: '3',
        name: 'Green Café, Delhi',
        city: 'Delhi',
        achievement: 'Sustainable Restaurant',
        description: 'Local café using only seasonal, local ingredients and zero plastic packaging.',
        co2Saved: 1200,
        category: 'food',
      ),
    ];
  }
}
