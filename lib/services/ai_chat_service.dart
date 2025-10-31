import 'dart:convert';
import 'package:http/http.dart' as http;

class AIChatService {
  // TODO: Add your Groq API key here or load from environment/config
  // Get your free API key from: https://console.groq.com
  static const String apiKey = 'YOUR_GROQ_API_KEY_HERE';
  static const String apiUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  final List<Map<String, String>> _chatHistory = [];

  AIChatService() {
    // Initialize with system context
    _chatHistory.add({
      'role': 'system',
      'content':
          "You are an AI assistant for Bhoomi, an eco-friendly lifestyle app. "
          "Your role is to help users with:\n"
          "1. Environmental tips and sustainable living advice\n"
          "2. Eco-friendly practices for daily life\n"
          "3. Information about reducing carbon footprint\n"
          "4. Green transportation options\n"
          "5. Waste management and recycling tips\n"
          "6. Energy conservation methods\n"
          "7. Sustainable shopping and consumption\n"
          "8. Climate change awareness\n"
          "9. Indian festivals and eco-friendly celebrations\n"
          "10. Community environmental initiatives\n\n"
          "Always provide practical, actionable advice. Keep responses concise but informative. "
          "Use emojis occasionally to make responses friendly. Focus on positive solutions rather than just problems. "
          "Relate advice to Indian context when relevant.",
    });
  }

  Future<String> sendMessage(String message) async {
    try {
      // Add user message to history
      _chatHistory.add({'role': 'user', 'content': message});

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mixtral-8x7b-32768',
          'messages': _chatHistory,
          'temperature': 0.7,
          'max_tokens': 1024,
          'top_p': 0.95,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;

        // Add AI response to history
        _chatHistory.add({'role': 'assistant', 'content': aiResponse});

        return aiResponse;
      } else {
        return "Sorry, I encountered an error. Please try again. (Status: ${response.statusCode})";
      }
    } catch (e) {
      return "Sorry, I encountered an error: ${e.toString()}. Please try again.";
    }
  }

  Future<List<String>> getSuggestions() async {
    return [
      "How can I reduce plastic waste at home?",
      "Tips for eco-friendly Diwali celebration",
      "Best ways to save electricity",
      "How to start composting?",
      "Sustainable transportation options in India",
      "Green shopping tips",
      "Water conservation methods",
      "Eco-friendly gift ideas",
    ];
  }

  void resetChat() {
    _chatHistory.clear();
    _chatHistory.add({
      'role': 'system',
      'content':
          "You are an AI assistant for Bhoomi, an eco-friendly lifestyle app. "
          "Your role is to help users with environmental tips and sustainable living advice. "
          "Keep responses concise, practical, and focused on Indian context when relevant.",
    });
  }
}
