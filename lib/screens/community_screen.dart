import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../models/community_models.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              AppTheme.leafGreen.withOpacity(0.15),
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
                    LocalEventsTab(),
                    EcoHeroesTab(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Connect & Take Action',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
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
          Tab(text: 'Local Events'),
          Tab(text: 'Eco Heroes'),
        ],
      ),
    );
  }
}

// Local Events Tab
class LocalEventsTab extends StatelessWidget {
  const LocalEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final events = LocalEvent.getSampleEvents();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(context, events[index]);
      },
    );
  }

  Widget _buildEventCard(BuildContext context, LocalEvent event) {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    Color categoryColor;
    IconData categoryIcon;

    switch (event.category) {
      case 'cleanup':
        categoryColor = AppTheme.skyBlue;
        categoryIcon = FontAwesomeIcons.broom;
        break;
      case 'workshop':
        categoryColor = AppTheme.sunYellow;
        categoryIcon = FontAwesomeIcons.chalkboardTeacher;
        break;
      case 'plantation':
        categoryColor = AppTheme.primaryGreen;
        categoryIcon = FontAwesomeIcons.seedling;
        break;
      default:
        categoryColor = AppTheme.leafGreen;
        categoryIcon = FontAwesomeIcons.bullhorn;
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoryColor, categoryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(categoryIcon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            event.city,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            event.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.calendar,
                      size: 16,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateFormatter.format(event.date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      FontAwesomeIcons.users,
                      size: 16,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${event.participants} joined',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.user,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'by ${event.organizer}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully registered for the event!'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColor,
              ),
              child: const Text('Join Event'),
            ),
          ),
        ],
      ),
    );
  }
}

// Eco Heroes Tab
class EcoHeroesTab extends StatelessWidget {
  const EcoHeroesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final heroes = EcoHero.getSampleHeroes();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        return _buildHeroCard(context, heroes[index]);
      },
    );
  }

  Widget _buildHeroCard(BuildContext context, EcoHero hero) {
    Color categoryColor;
    IconData categoryIcon;

    switch (hero.category) {
      case 'waste':
        categoryColor = AppTheme.accentPurple;
        categoryIcon = FontAwesomeIcons.recycle;
        break;
      case 'energy':
        categoryColor = AppTheme.sunYellow;
        categoryIcon = FontAwesomeIcons.solarPanel;
        break;
      case 'food':
        categoryColor = AppTheme.leafGreen;
        categoryIcon = FontAwesomeIcons.leaf;
        break;
      default:
        categoryColor = AppTheme.primaryGreen;
        categoryIcon = FontAwesomeIcons.medal;
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoryColor, categoryColor.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.glassBoxShadow,
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          hero.city,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.star,
                      size: 12,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Hero',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [categoryColor.withOpacity(0.2), categoryColor.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hero.achievement,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: categoryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hero.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.leaf,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Saved ${hero.co2Saved.toStringAsFixed(0)} kg CO₂',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
