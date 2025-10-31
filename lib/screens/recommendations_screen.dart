import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recommendation_model.dart';
import '../providers/language_provider.dart';

/// Recommendations Screen
/// Shows AI-driven personalized eco-action recommendations

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<EcoRecommendation> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);

    final recs = RecommendationEngine.generateRecommendations(
      userCity: 'Delhi', // TODO: Get from location service
      carbonFootprint: 150.0, // TODO: Get from user profile
      userHabits: {
        'uses_public_transport': true,
        'recycles': true,
        'plants_trees': false,
      },
    );

    setState(() {
      _recommendations = recs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isHindi = languageProvider.currentLocale.languageCode == 'hi';

    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isHindi ? 'सिफारिशें' : 'Recommendations',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadRecommendations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : RefreshIndicator(
              onRefresh: _loadRecommendations,
              child: _recommendations.isEmpty
                  ? Center(
                      child: Text(
                        isHindi
                            ? 'कोई सिफारिशें नहीं'
                            : 'No recommendations available',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _recommendations.length,
                      itemBuilder: (context, index) {
                        final rec = _recommendations[index];
                        return _buildRecommendationCard(rec, isHindi);
                      },
                    ),
            ),
    );
  }

  Widget _buildRecommendationCard(EcoRecommendation rec, bool isHindi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getGradientColors(rec.category),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with priority badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getTypeLabel(rec.category, isHindi),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${rec.priority}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isHindi ? rec.titleHi : rec.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                isHindi ? rec.descriptionHi : rec.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Impact metrics
              Row(
                children: [
                  _buildMetric(
                    '💰',
                    '₹${rec.potentialSavings.toStringAsFixed(0)}',
                    isHindi ? 'बचत' : 'Savings',
                  ),
                  const SizedBox(width: 16),
                  _buildMetric(
                    '🌱',
                    '${rec.co2Reduction.toStringAsFixed(1)}kg',
                    'CO₂',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action steps
              ...rec.actionSteps.map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✓ ', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Text(
                          step,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Complete button
              ElevatedButton(
                onPressed: () {
                  // TODO: Mark as completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isHindi
                            ? 'बढ़िया! आपने +${rec.priority} अंक अर्जित किए'
                            : 'Great! You earned +${rec.priority} points',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A1931),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isHindi ? 'पूरा करें' : 'Mark Complete'),
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle_outline),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String emoji, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(RecommendationType type) {
    switch (type) {
      case RecommendationType.festival:
        return [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)];
      case RecommendationType.pollution:
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A6F)];
      case RecommendationType.seasonal:
        return [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
      case RecommendationType.transport:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case RecommendationType.energy:
        return [const Color(0xFFF093FB), const Color(0xFFF5576C)];
      case RecommendationType.food:
        return [const Color(0xFF43E97B), const Color(0xFF38F9D7)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  String _getTypeLabel(RecommendationType type, bool isHindi) {
    if (isHindi) {
      switch (type) {
        case RecommendationType.festival:
          return 'त्योहार';
        case RecommendationType.pollution:
          return 'प्रदूषण';
        case RecommendationType.seasonal:
          return 'मौसमी';
        case RecommendationType.transport:
          return 'परिवहन';
        case RecommendationType.energy:
          return 'ऊर्जा';
        case RecommendationType.food:
          return 'भोजन';
        default:
          return 'सामान्य';
      }
    } else {
      return type.toString().split('.').last.toUpperCase();
    }
  }
}
