import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/language_selector.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Not specified';

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _nameController.text = appState.userName;
    _cityController.text = appState.userCity;
    _ageController.text = appState.userAge > 0 ? appState.userAge.toString() : '';
    _selectedGender = appState.userGender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildAppBar(context),
                const SizedBox(height: 30),
                _buildProfileHeader(appState),
                const SizedBox(height: 20),
                const LanguageSelector(),
                const SizedBox(height: 20),
                _buildProfileForm(),
                const SizedBox(height: 20),
                _buildStats(appState),
                const SizedBox(height: 20),
                _buildAchievements(appState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildProfileHeader(AppState appState) {
    return GlassCard(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.glassBoxShadow,
            ),
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            appState.userName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 5),
          Text(
            appState.userCity,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appState.carbonFootprint.getEcoLevel(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.editProfile,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.name,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.city,
              prefixIcon: const Icon(Icons.location_city),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.age,
              prefixIcon: const Icon(Icons.cake_outlined),
              hintText: AppLocalizations.of(context)!.enterYourAge,
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.gender,
              prefixIcon: const Icon(Icons.person_pin_outlined),
            ),
            items: [
              DropdownMenuItem(value: 'Male', child: Text(AppLocalizations.of(context)!.male)),
              DropdownMenuItem(value: 'Female', child: Text(AppLocalizations.of(context)!.female)),
              DropdownMenuItem(value: 'Other', child: Text(AppLocalizations.of(context)!.other)),
              DropdownMenuItem(value: 'Prefer not to say', child: Text(AppLocalizations.of(context)!.preferNotToSay)),
              DropdownMenuItem(value: 'Not specified', child: Text(AppLocalizations.of(context)!.notSpecified)),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value ?? 'Not specified';
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final appState = Provider.of<AppState>(context, listen: false);
                final age = int.tryParse(_ageController.text) ?? 0;
                appState.updateUserProfile(
                  _nameController.text,
                  _cityController.text,
                  age: age,
                  gender: _selectedGender,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.profileUpdated),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.saveChanges),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Impact',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.fire,
                      color: AppTheme.sunYellow,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${appState.streakDays}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.sunYellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Day Streak',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.tree,
                      color: AppTheme.primaryGreen,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${appState.getTreesEquivalent()}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Trees',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Savings',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${appState.getMonthlySavings().toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.indianRupeeSign,
                  color: AppTheme.primaryGreen,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        GlassCard(
          child: Column(
            children: [
              _buildAchievementItem(
                'First Steps',
                'Completed your first carbon calculation',
                FontAwesomeIcons.trophy,
                AppTheme.sunYellow,
                true,
              ),
              const Divider(height: 30),
              _buildAchievementItem(
                'Week Warrior',
                'Maintained 7-day streak',
                FontAwesomeIcons.fire,
                AppTheme.primaryGreen,
                appState.streakDays >= 7,
              ),
              const Divider(height: 30),
              _buildAchievementItem(
                'Community Helper',
                'Joined a local event',
                FontAwesomeIcons.handshake,
                AppTheme.skyBlue,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    String title,
    String description,
    IconData icon,
    Color color,
    bool isUnlocked,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnlocked ? color.withOpacity(0.2) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isUnlocked ? color : Colors.grey,
            size: 28,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? AppTheme.textPrimary : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked ? AppTheme.textSecondary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (isUnlocked)
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryGreen,
            size: 24,
          ),
      ],
    );
  }
}
