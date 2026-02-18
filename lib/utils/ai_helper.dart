import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIHelper {
  static final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Generates treatment recommendations for a detected disease
  static Future<String> getTreatmentRecommendations({
    required String diseaseName,
    required String diseaseDescription,
    required double confidence,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini', // or "gpt-4" / "gpt-3.5-turbo"
          'max_tokens': 1024,
          'messages': [
            {
              'role': 'user',
              'content':
                  '''
Based on the detected skin condition, provide treatment recommendations:

Disease: $diseaseName
Description: $diseaseDescription
Detection Confidence: ${(confidence * 100).toStringAsFixed(1)}%

Please provide:
1. General information about this condition
2. Recommended next steps
3. When to see a doctor
4. Home care tips (if applicable)
5. Important warnings

Keep the response clear, concise, and easy to understand. Format with bullet points for readability.

IMPORTANT DISCLAIMER: This is for educational purposes only and should not replace professional medical advice.
''',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List;

        if (choices.isNotEmpty) {
          return choices[0]['message']['content'] ??
              'Unable to generate recommendations at this time.';
        }
        return 'Unable to generate recommendations at this time.';
      } else {
        return 'Error: Unable to fetch AI recommendations. Please try again later.';
      }
    } catch (e) {
      return 'Error connecting to AI service: ${e.toString()}';
    }
  }

  /// Provides a brief educational overview of a disease
  static Future<String> getDetailedDiseaseInfo(String diseaseName) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini', // or "gpt-4" / "gpt-3.5-turbo"
          'max_tokens': 512,
          'messages': [
            {
              'role': 'user',
              'content':
                  'Provide a brief, educational overview of $diseaseName in 3-4 sentences. Focus on what it is, common symptoms, and who is at risk. Keep it simple and non-alarming.',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List;

        if (choices.isNotEmpty) {
          return choices[0]['message']['content'] ??
              'Information not available at this time.';
        }
      }

      return 'Information not available at this time.';
    } catch (e) {
      return 'Unable to load detailed information.';
    }
  }

  /// Fetches multiple disease overviews
  static Future<Map<String, String>> getMultipleDiseaseInfos(
    List<String> diseaseNames,
  ) async {
    Map<String, String> results = {};

    for (String disease in diseaseNames) {
      results[disease] = await getDetailedDiseaseInfo(disease);
      // Add small delay to respect API rate limits
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return results;
  }
}
