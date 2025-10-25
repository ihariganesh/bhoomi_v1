import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/app_state.dart';
import '../models/carbon_calculator.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryGreen.withOpacity(0.15),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    TransportationTab(),
                    FoodTab(),
                    EnergyTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            'Carbon Calculator',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Transport'),
          Tab(text: 'Food'),
          Tab(text: 'Energy'),
        ],
      ),
    );
  }
}

// Transportation Tab
class TransportationTab extends StatefulWidget {
  const TransportationTab({super.key});

  @override
  State<TransportationTab> createState() => _TransportationTabState();
}

class _TransportationTabState extends State<TransportationTab> {
  String _vehicleType = 'two_wheeler';
  double _weeklyFuelSpend = 0;
  double _weeklyDistance = 0;
  int _autoBusFrequency = 0;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _vehicleType = appState.transportation.vehicleType;
    _weeklyFuelSpend = appState.transportation.weeklyFuelSpend;
    _weeklyDistance = appState.transportation.weeklyDistance;
    _autoBusFrequency = appState.transportation.autoBusFrequency;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Transportation',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          _buildVehicleTypeSelector(),
          const SizedBox(height: 20),
          _buildFuelSpendInput(),
          const SizedBox(height: 20),
          _buildDistanceInput(),
          const SizedBox(height: 20),
          _buildPublicTransportInput(),
          const SizedBox(height: 30),
          _buildSaveButton(),
          const SizedBox(height: 20),
          _buildResultCard(),
        ],
      ),
    );
  }

  Widget _buildVehicleTypeSelector() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Vehicle',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildVehicleChip('Two Wheeler', 'two_wheeler', FontAwesomeIcons.motorcycle),
              _buildVehicleChip('Car (Petrol)', 'car_petrol', FontAwesomeIcons.car),
              _buildVehicleChip('Car (Diesel)', 'car_diesel', FontAwesomeIcons.car),
              _buildVehicleChip('Auto', 'auto', FontAwesomeIcons.taxi),
              _buildVehicleChip('Bus', 'bus', FontAwesomeIcons.bus),
              _buildVehicleChip('E-Vehicle', 'electric_vehicle', FontAwesomeIcons.bolt),
              _buildVehicleChip('Bicycle', 'bicycle', FontAwesomeIcons.bicycle),
              _buildVehicleChip('Walk', 'walk', FontAwesomeIcons.personWalking),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleChip(String label, String value, IconData icon) {
    final isSelected = _vehicleType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _vehicleType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelSpendInput() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Fuel Spend (₹)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              prefixText: '₹ ',
            ),
            onChanged: (value) {
              setState(() {
                _weeklyFuelSpend = double.tryParse(value) ?? 0;
              });
            },
            controller: TextEditingController(
              text: _weeklyFuelSpend > 0 ? _weeklyFuelSpend.toString() : '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceInput() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Distance (km)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter distance',
              suffixText: 'km',
            ),
            onChanged: (value) {
              setState(() {
                _weeklyDistance = double.tryParse(value) ?? 0;
              });
            },
            controller: TextEditingController(
              text: _weeklyDistance > 0 ? _weeklyDistance.toString() : '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicTransportInput() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auto/Bus Usage',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Times per week: $_autoBusFrequency',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Slider(
            value: _autoBusFrequency.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            activeColor: AppTheme.primaryGreen,
            label: _autoBusFrequency.toString(),
            onChanged: (value) {
              setState(() {
                _autoBusFrequency = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final appState = Provider.of<AppState>(context, listen: false);
          appState.updateTransportation(
            TransportationData(
              vehicleType: _vehicleType,
              weeklyFuelSpend: _weeklyFuelSpend,
              weeklyDistance: _weeklyDistance,
              autoBusFrequency: _autoBusFrequency,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transportation data saved!'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
        child: const Text('Save Data'),
      ),
    );
  }

  Widget _buildResultCard() {
    final data = TransportationData(
      vehicleType: _vehicleType,
      weeklyFuelSpend: _weeklyFuelSpend,
      weeklyDistance: _weeklyDistance,
      autoBusFrequency: _autoBusFrequency,
    );
    final monthlyCO2 = data.calculateMonthlyCO2();

    return GlassCard(
      color: AppTheme.primaryGreen.withOpacity(0.2),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.chartLine,
            color: AppTheme.primaryGreen,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            'Monthly CO₂ Emissions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            '${monthlyCO2.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Food Tab
class FoodTab extends StatefulWidget {
  const FoodTab({super.key});

  @override
  State<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  int _nonVegMeals = 3;
  int _dairyFreeDays = 0;
  int _localFoodDays = 0;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _nonVegMeals = appState.food.nonVegMealsPerWeek;
    _dairyFreeDays = appState.food.dairyFreeDaysPerWeek;
    _localFoodDays = appState.food.localFoodDaysPerWeek;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Food Habits',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          _buildNonVegMealsSlider(),
          const SizedBox(height: 20),
          _buildDairyFreeDaysSlider(),
          const SizedBox(height: 20),
          _buildLocalFoodDaysSlider(),
          const SizedBox(height: 30),
          _buildSaveButton(),
          const SizedBox(height: 20),
          _buildResultCard(),
          const SizedBox(height: 20),
          _buildTips(),
        ],
      ),
    );
  }

  Widget _buildNonVegMealsSlider() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.drumstickBite, color: AppTheme.sunYellow),
              const SizedBox(width: 10),
              Text(
                'Non-Veg Meals per Week',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$_nonVegMeals meals',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
          Slider(
            value: _nonVegMeals.toDouble(),
            min: 0,
            max: 21,
            divisions: 21,
            activeColor: AppTheme.primaryGreen,
            label: _nonVegMeals.toString(),
            onChanged: (value) {
              setState(() {
                _nonVegMeals = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDairyFreeDaysSlider() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.leaf, color: AppTheme.leafGreen),
              const SizedBox(width: 10),
              Text(
                'Dairy-Free Days per Week',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$_dairyFreeDays days',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
          Slider(
            value: _dairyFreeDays.toDouble(),
            min: 0,
            max: 7,
            divisions: 7,
            activeColor: AppTheme.leafGreen,
            label: _dairyFreeDays.toString(),
            onChanged: (value) {
              setState(() {
                _dairyFreeDays = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocalFoodDaysSlider() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.seedling, color: AppTheme.primaryGreen),
              const SizedBox(width: 10),
              Text(
                'Local Food Days per Week',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$_localFoodDays days',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
          Slider(
            value: _localFoodDays.toDouble(),
            min: 0,
            max: 7,
            divisions: 7,
            activeColor: AppTheme.primaryGreen,
            label: _localFoodDays.toString(),
            onChanged: (value) {
              setState(() {
                _localFoodDays = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final appState = Provider.of<AppState>(context, listen: false);
          appState.updateFood(
            FoodData(
              nonVegMealsPerWeek: _nonVegMeals,
              dairyFreeDaysPerWeek: _dairyFreeDays,
              localFoodDaysPerWeek: _localFoodDays,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Food data saved!'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
        child: const Text('Save Data'),
      ),
    );
  }

  Widget _buildResultCard() {
    final data = FoodData(
      nonVegMealsPerWeek: _nonVegMeals,
      dairyFreeDaysPerWeek: _dairyFreeDays,
      localFoodDaysPerWeek: _localFoodDays,
    );
    final monthlyCO2 = data.calculateMonthlyCO2();

    return GlassCard(
      color: AppTheme.sunYellow.withOpacity(0.2),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.chartLine,
            color: AppTheme.sunYellow,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            'Monthly CO₂ Emissions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            '${monthlyCO2.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.sunYellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return GlassCard(
      color: AppTheme.leafGreen.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates, color: AppTheme.primaryGreen),
              const SizedBox(width: 10),
              Text(
                'Quick Tips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '• Going vegetarian 1 day/week saves 20 kg CO₂ monthly\n'
            '• Local produce reduces food miles by 50%\n'
            '• Plant-based proteins are climate-friendly',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// Energy Tab
class EnergyTab extends StatefulWidget {
  const EnergyTab({super.key});

  @override
  State<EnergyTab> createState() => _EnergyTabState();
}

class _EnergyTabState extends State<EnergyTab> {
  double _electricityUnits = 200;
  String _selectedState = 'Maharashtra';

  final List<String> _indianStates = [
    'Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Gujarat',
    'Uttar Pradesh', 'West Bengal', 'Rajasthan', 'Kerala',
    'Himachal Pradesh', 'Punjab', 'Haryana', 'Bihar',
    'Madhya Pradesh', 'Andhra Pradesh', 'Telangana', 'Odisha', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _electricityUnits = appState.energy.monthlyElectricityUnits;
    _selectedState = appState.energy.state;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Energy Usage',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          _buildStateSelector(),
          const SizedBox(height: 20),
          _buildElectricityInput(),
          const SizedBox(height: 30),
          _buildSaveButton(),
          const SizedBox(height: 20),
          _buildResultCard(),
          const SizedBox(height: 20),
          _buildEnergySavingTips(),
        ],
      ),
    );
  }

  Widget _buildStateSelector() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your State',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _selectedState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: _indianStates.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedState = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildElectricityInput() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FontAwesomeIcons.bolt, color: AppTheme.sunYellow),
              const SizedBox(width: 10),
              Text(
                'Monthly Electricity (kWh)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${_electricityUnits.toStringAsFixed(0)} kWh',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.primaryGreen,
            ),
          ),
          Slider(
            value: _electricityUnits,
            min: 0,
            max: 1000,
            divisions: 100,
            activeColor: AppTheme.primaryGreen,
            label: _electricityUnits.toStringAsFixed(0),
            onChanged: (value) {
              setState(() {
                _electricityUnits = value;
              });
            },
          ),
          Text(
            'Check your electricity bill for exact units',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final appState = Provider.of<AppState>(context, listen: false);
          appState.updateEnergy(
            EnergyData(
              monthlyElectricityUnits: _electricityUnits,
              state: _selectedState,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Energy data saved!'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
        child: const Text('Save Data'),
      ),
    );
  }

  Widget _buildResultCard() {
    final data = EnergyData(
      monthlyElectricityUnits: _electricityUnits,
      state: _selectedState,
    );
    final monthlyCO2 = data.calculateMonthlyCO2();
    final gridFactor = EnergyData.stateGridFactors[_selectedState] ?? 0.80;

    return GlassCard(
      color: AppTheme.skyBlue.withOpacity(0.2),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.chartLine,
            color: AppTheme.skyBlue,
            size: 40,
          ),
          const SizedBox(height: 15),
          Text(
            'Monthly CO₂ Emissions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Text(
            '${monthlyCO2.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppTheme.skyBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Grid factor: $gridFactor kg CO₂/kWh',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEnergySavingTips() {
    return GlassCard(
      color: AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.energy_savings_leaf, color: AppTheme.primaryGreen),
              const SizedBox(width: 10),
              Text(
                'Energy Saving Tips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '• Use inverter AC to save 30-50% electricity\n'
            '• Replace all bulbs with LED (saves 75% energy)\n'
            '• Unplug devices when not in use\n'
            '• Use natural light during day',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
