import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/app_state.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final footprint = appState.carbonFootprint;
    final breakdown = footprint.getBreakdown();
    final comparison = footprint.getComparison();
    final recommendations = footprint.getRecommendations();
    final treesNeeded = footprint.getTreesNeeded();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTotalEmissionsCard(footprint, context),
                const SizedBox(height: 24),
                _buildEcoScoreCard(footprint, context),
                const SizedBox(height: 24),
                _buildComparisonCard(comparison, context),
                const SizedBox(height: 24),
                _buildBreakdownCard(breakdown, footprint, context),
                const SizedBox(height: 24),
                _buildTreesCard(treesNeeded, context),
                const SizedBox(height: 24),
                _buildRecommendationsCard(recommendations, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        Text(
          'Your Carbon Footprint',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalEmissionsCard(dynamic footprint, BuildContext context) {
    return GlassCard(
      gradient: AppTheme.tealGradient,
      enableHoverEffect: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.cloudArrowUp,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Monthly CO₂ Emissions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${footprint.getTotalMonthlyCO2().toStringAsFixed(1)} kg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${footprint.getTotalYearlyCO2().toStringAsFixed(0)} kg per year',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoScoreCard(dynamic footprint, BuildContext context) {
    final score = footprint.calculateEcoScore();
    final level = footprint.getEcoLevel();
    final color = score >= 60 ? AppTheme.primaryGreen : 
                  score >= 40 ? AppTheme.sunYellow : 
                  AppTheme.errorRed;

    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eco-Score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    level,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.6), color],
                  ),
                ),
                child: Center(
                  child: Text(
                    '${score.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(Map<String, dynamic> comparison, BuildContext context) {
    final isAboveAvg = comparison['isAboveAverage'] as bool;
    final percentDiff = (comparison['percentDiff'] as double).abs();

    return GlassCard(
      color: isAboveAvg ? AppTheme.errorRed.withOpacity(0.1) : AppTheme.primaryGreen.withOpacity(0.1),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isAboveAvg ? FontAwesomeIcons.arrowTrendUp : FontAwesomeIcons.arrowTrendDown,
                color: isAboveAvg ? AppTheme.errorRed : AppTheme.primaryGreen,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAboveAvg ? 'Above Average' : 'Below Average',
                      style: TextStyle(
                        color: isAboveAvg ? AppTheme.errorRed : AppTheme.primaryGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your emissions are ${percentDiff.toStringAsFixed(0)}% ${isAboveAvg ? "higher" : "lower"} than average Indian',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: _buildStatItem(
                  'You',
                  '${(comparison['userEmissions'] as double).toStringAsFixed(0)} kg/year',
                  AppTheme.accentPurple,
                ),
              ),
              Flexible(
                child: _buildStatItem(
                  'Average',
                  '${(comparison['avgEmissions'] as double).toStringAsFixed(0)} kg/year',
                  AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(Map<String, double> breakdown, dynamic footprint, BuildContext context) {
    final total = footprint.getTotalMonthlyCO2();
    final transportPercent = (breakdown['transportation']! / total * 100);
    final foodPercent = (breakdown['food']! / total * 100);
    final energyPercent = (breakdown['energy']! / total * 100);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emissions Breakdown',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildBreakdownItem(
            'Transportation',
            breakdown['transportation']!,
            transportPercent,
            FontAwesomeIcons.car,
            AppTheme.accentBlue,
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'Food',
            breakdown['food']!,
            foodPercent,
            FontAwesomeIcons.utensils,
            AppTheme.sunYellow,
          ),
          const SizedBox(height: 12),
          _buildBreakdownItem(
            'Energy',
            breakdown['energy']!,
            energyPercent,
            FontAwesomeIcons.bolt,
            AppTheme.accentPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String label, double co2, double percent, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${co2.toStringAsFixed(1)} kg',
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTreesCard(int treesNeeded, BuildContext context) {
    return GlassCard(
      gradient: AppTheme.greenGradient,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FontAwesomeIcons.tree,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$treesNeeded Trees',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'needed to offset your yearly emissions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard(List<String> recommendations, BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.lightbulb,
                color: AppTheme.sunYellow,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Personalized Tips',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
