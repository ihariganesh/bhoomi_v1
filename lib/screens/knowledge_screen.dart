import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/community_models.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  String _selectedCategory = 'all';
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final capsules = KnowledgeCapsule.getSampleCapsules();
    final filteredCapsules = _selectedCategory == 'all'
        ? capsules
        : capsules.where((c) => c.category == _selectedCategory).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.skyBlue.withOpacity(0.15),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildFilters(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredCapsules.length,
                  itemBuilder: (context, index) {
                    return _buildKnowledgeCard(context, filteredCapsules[index]);
                  },
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
                'Gyan Kendra',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Knowledge Hub',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildLanguageToggle(),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildLanguageButton('EN', 'en'),
          _buildLanguageButton('हिं', 'hi'),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String label, String lang) {
    final isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = lang;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', 'all', FontAwesomeIcons.globe),
          _buildFilterChip('Transport', 'transportation', FontAwesomeIcons.car),
          _buildFilterChip('Food', 'food', FontAwesomeIcons.utensils),
          _buildFilterChip('Energy', 'energy', FontAwesomeIcons.bolt),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? AppTheme.glassBoxShadow : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              size: 18,
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

  Widget _buildKnowledgeCard(BuildContext context, KnowledgeCapsule capsule) {
    final title = _selectedLanguage == 'hi' ? capsule.titleHi : capsule.titleEn;
    final description = _selectedLanguage == 'hi' ? capsule.descriptionHi : capsule.descriptionEn;
    final impact = _selectedLanguage == 'hi' ? capsule.impactHi : capsule.impactEn;

    Color categoryColor;
    IconData categoryIcon;
    
    switch (capsule.category) {
      case 'transportation':
        categoryColor = AppTheme.skyBlue;
        categoryIcon = FontAwesomeIcons.car;
        break;
      case 'food':
        categoryColor = AppTheme.sunYellow;
        categoryIcon = FontAwesomeIcons.utensils;
        break;
      case 'energy':
        categoryColor = AppTheme.primaryGreen;
        categoryIcon = FontAwesomeIcons.bolt;
        break;
      default:
        categoryColor = AppTheme.leafGreen;
        categoryIcon = FontAwesomeIcons.leaf;
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: categoryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
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
              children: [
                const Icon(
                  FontAwesomeIcons.chartLine,
                  color: AppTheme.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
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
