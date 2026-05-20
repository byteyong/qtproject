// lib/services/ai_service.dart 수정
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static const String _apiKey = 'AIzaSyD-doY1un3ZretrpDBZnEmXSl1Z1pstjY8';

  static Future<List<String>> generateQTQuestions({
    required String chapterTitle,
    required List<String> verseTexts,
  }) async {
    // 1. 모델명을 'gemini-1.5-flash'로 설정 (에러 지속 시 'gemini-pro'로 변경)
    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

    // 2. 프롬프트 보강: JSON 형식 강제 및 예시 제공
    final prompt = '''
      본문: $chapterTitle
      내용: ${verseTexts.take(15).join('\n')}
      
      위 본문을 바탕으로 개인의 삶에 적용할 수 있는 QT 질문 3개를 만드세요.
      규칙:
      - 짧고 명확하게 한 문장으로 작성
      - 다른 설명 없이 반드시 아래와 같은 JSON 배열 형식으로만 응답할 것
      예시: ["질문1", "질문2", "질문3"]
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        // 3. 마크다운 태그 제거 및 클리닝
        final cleaned = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final decoded = jsonDecode(cleaned);
        return List<String>.from(decoded);
      }
    } catch (e) {
      print('Gemini API Error: $e');
    }
    return _defaultQuestions();
  }

  static List<String> _defaultQuestions() => [
        '하나님의 사랑이 내 삶에서 어떻게 나타나고 있나요?',
        '영생을 얻는다는 것이 오늘 내게 어떤 의미인가요?',
        '이 말씀을 통해 누군가에게 전하고 싶은 것은 무엇인가요?',
      ];
}
