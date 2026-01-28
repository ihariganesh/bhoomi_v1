# 🌱 Bhoomi - Sustainable Living App

## ⚠️ **WORK IN PROGRESS - UNFINISHED PROJECT**

**Bhoomi** (भूमि - meaning "Earth" in Hindi/Tamil: பூமி) is a comprehensive Flutter app designed to empower individuals in India to measurably reduce their carbon footprint through localized, actionable knowledge and community engagement.

**Current Status**: This project is actively under development. Many features are partially implemented or not yet completed. See the "Known Issues & TODO" section below.

## ✨ Features

### 1. 📊 Carbon Calculator & Habit Builder

Track and reduce your carbon emissions across three key areas:

#### **Transportation**
- Calculate emissions from two-wheelers, cars, autos, and public transport
- Indian-specific vehicle types and fuel consumption patterns
- Weekly fuel spend or distance tracking
- Support for electric vehicles and eco-friendly options

#### **Food**
- Track non-vegetarian meals per week
- Monitor dairy-free days
- Encourage local food purchases
- Indian dietary patterns (vegetarian vs non-vegetarian)

#### **Energy**
- State-wise grid carbon factors across India
- Monthly electricity unit tracking
- Appliance-specific energy consumption
- Regional power mix considerations (hydro-heavy states vs coal-dependent states)

### 2. 🎯 Eco-Score & Gamification

- **Dynamic Eco-Score**: 0-100 score based on your carbon footprint
- **Eco Levels**: Progress from "Getting Started" to "Eco Champion"
- **Streak Tracking**: Maintain daily habits and build momentum
- **Achievements**: Unlock badges for sustainable milestones
- **Visual Progress**: Beautiful circular progress indicators with glassmorphism effects

### 3. 📚 Gyan Kendra (Knowledge Hub)

Educational content in **Hindi and English**:

- Energy-saving tips (LED bulbs, inverter ACs, etc.)
- Food choices impact (Meatless Mondays, local produce)
- Transportation alternatives (public transport, carpooling)
- Real savings calculations in ₹ (Rupees)
- CO₂ reduction metrics for each tip

### 4. 🤝 Community Features

#### **Local Action Board**
- Beach cleanups
- Tree plantation drives
- Composting workshops
- Awareness campaigns
- City-wise event filtering
- Join events and track participation

#### **Eco-Heroes**
- Spotlight on local sustainability champions
- Success stories from your city
- Verified CO₂ savings achievements
- Inspiration from real people and businesses

### 5. 👤 Profile & Impact Tracking

- Personal carbon footprint dashboard
- Monthly savings in rupees
- Trees equivalent metric
- Achievement badges
- Streak days counter
- Customizable user profile

## 🎨 Design Highlights

### Glassmorphism UI
- Modern frosted-glass effect cards
- Beautiful gradient backgrounds
- Smooth animations and transitions
- Interactive elements with depth

### Color Theme - Sustainable Living
- **Primary Green**: `#2ECC71` - Growth and nature
- **Leaf Green**: `#52B788` - Freshness
- **Sky Blue**: `#3498DB` - Clean air
- **Sun Yellow**: `#F39C12` - Solar energy
- **Earth Brown**: `#8B7355` - Grounding

### Age-Inclusive Design
- Large, readable fonts (Google Fonts - Poppins & Inter)
- Clear icons from FontAwesome
- Intuitive navigation
- Simple sliders and inputs
- Visual feedback for all actions

## 📱 Screenshots

*(Add screenshots of your app here)*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio IDE

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/ihariganesh/bhoomi_v1.git
cd bhoomi_v1
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building for Production

**Android**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point with splash screen
├── models/
│   ├── carbon_calculator.dart    # Carbon calculation logic
│   └── community_models.dart     # Knowledge & community models
├── providers/
│   └── app_state.dart            # State management with Provider
├── screens/
│   ├── home_screen.dart          # Main dashboard
│   ├── calculator_screen.dart    # Carbon calculator tabs
│   ├── knowledge_screen.dart     # Gyan Kendra
│   ├── community_screen.dart     # Events & Eco Heroes
│   └── profile_screen.dart       # User profile
├── utils/
│   └── app_theme.dart            # Theme configuration
└── widgets/
    └── glass_card.dart           # Reusable glassmorphism card
```

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **SharedPreferences**: Local data persistence
- **Google Fonts**: Beautiful typography (Poppins & Inter)
- **FontAwesome**: Comprehensive icon library
- **FL Chart**: Data visualization
- **Percent Indicator**: Progress circles
- **Glassmorphism**: Modern UI effects
- **Intl**: Internationalization (Hindi + English)

## 📊 Carbon Calculation Methodology

### Transportation
- **Emission Factors**: Based on typical Indian vehicle fleet
  - Two-wheeler: 0.08 kg CO₂/km
  - Car (Petrol): 0.18 kg CO₂/km
  - Auto: 0.12 kg CO₂/km
  - Bus: 0.04 kg CO₂/km per passenger
  
### Food
- **Meal Emissions**:
  - Non-veg meal: 7.2 kg CO₂
  - Vegetarian meal: 2.0 kg CO₂
  - Dairy consumption: 1.5 kg CO₂/day

### Energy
- **State-wise Grid Factors** (kg CO₂/kWh):
  - West Bengal: 0.92 (coal-heavy)
  - Kerala: 0.55 (hydro-dominant)
  - Himachal Pradesh: 0.30 (mostly hydro)
  - National Average: 0.80

## 🌍 Impact Metrics

- **Average Indian Carbon Footprint**: 1.9 tons CO₂/year
- **1 Tree Absorption**: ~21 kg CO₂/year
- **Eco-Score Calculation**: Based on comparison to national average

## 🔮 Future Enhancements

- [ ] Social sharing of achievements
- [ ] Challenges and competitions
- [ ] Integration with local NGOs
- [ ] Waste tracking module
- [ ] Water conservation tracking
- [ ] Carbon offset marketplace
- [ ] Augmented Reality for plantation tracking
- [ ] Voice input in regional languages
- [ ] Offline mode
- [ ] Push notifications for tips and reminders

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👥 Authors

- **Hariganesh** - *Initial work* - [ihariganesh](https://github.com/ihariganesh)

## 🙏 Acknowledgments

- Carbon emission data from Indian environmental agencies
- Community feedback from sustainability experts
- Design inspiration from modern mobile apps
- Flutter community for excellent packages

## 📞 Support

For support, create an issue in this repository at [github.com/ihariganesh/bhoomi_v1/issues](https://github.com/ihariganesh/bhoomi_v1/issues).

---

## 🐛 Known Issues & TODO

### Critical Issues:
- ⚠️ **Localization incomplete** - Translation files exist but not integrated in all UI screens
- ⚠️ **Google Sign-In name** - User name from Google account not updating to profile properly
- ⚠️ **Some UI overflow issues** - On certain screen sizes, buttons may overflow

### TODO List:
- [ ] Complete UI localization across all screens (English, Hindi, Tamil)
- [ ] Fix Google Sign-In profile name persistence
- [ ] Implement Knowledge/Learning section
- [ ] Add Community features (challenges, leaderboards)
- [ ] Create Achievement/Badge system
- [ ] Add historical tracking with charts
- [ ] Implement cloud backup and sync
- [ ] Add offline mode support
- [ ] Create onboarding tutorial
- [ ] Fix all overflow and alignment issues
- [ ] Add unit tests
- [ ] Optimize performance

**Last Updated**: October 2025
---

**Made with 💚 for a sustainable India** 🇮🇳
