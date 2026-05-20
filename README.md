# 📖 성경 QT 앱 — Flutter 실행 가이드

---

## 📁 폴더 구조 (전체)

```
bible_qt_app/                    ← 프로젝트 루트 (VSCode에서 이 폴더를 열기)
│
├── pubspec.yaml                 ← 패키지 설정 (npm의 package.json과 같은 역할)
│
├── assets/
│   └── bible/
│       └── john_3.txt           ← 성경 본문 텍스트 (매일 교체할 파일)
│
└── lib/                         ← 모든 Dart 코드가 여기에!
    │
    ├── main.dart                ← ⭐ 앱 진입점 (Flutter가 맨 처음 실행하는 파일)
    │
    ├── models/
    │   └── bible_verse.dart     ← 데이터 모델 (BibleVerse, SharingPost 등)
    │
    ├── services/
    │   ├── ai_service.dart      ← Claude AI API 호출
    │   └── bible_service.dart   ← 성경 텍스트 파일 로드
    │
    ├── widgets/                 ← 재사용 가능한 UI 컴포넌트
    │   ├── app_colors.dart      ← 색상 상수
    │   ├── bible_verse_list.dart← 성경 구절 목록
    │   ├── qt_question_card.dart← 묵상 질문 카드
    │   └── meditation_card.dart ← 나의 묵상 입력 카드
    │
    └── screens/                 ← 각 화면
        ├── home_screen.dart     ← 홈 (말씀 + 묵상)
        ├── sharing_screen.dart  ← 나눔 피드
        └── calendar_screen.dart ← 묵상 캘린더
```

---

## 🚀 처음 실행하는 방법 (단계별)

### 1단계: Flutter SDK 설치

1. https://flutter.dev/docs/get-started/install 접속
2. 운영체제(Windows/Mac/Linux) 선택 후 설치
3. **Web 또는 Chrome** 대상도 함께 설정하면 브라우저에서도 실행 가능

설치 확인:
```bash
flutter doctor
```
모든 항목이 ✓ 이면 준비 완료.

---

### 2단계: VSCode 확장 설치

VSCode 확장 탭(Ctrl+Shift+X)에서 설치:
- **Flutter** (Dart 포함, Google 공식)
- **Dart** (자동으로 같이 설치됨)

---

### 3단계: 프로젝트 열기

1. VSCode에서 `파일 → 폴더 열기`
2. `bible_qt_app` 폴더 선택 (pubspec.yaml이 있는 폴더)

---

### 4단계: 패키지 설치

VSCode 터미널(Ctrl+`) 에서:
```bash
flutter pub get
```

---

### 5단계: API 키 설정

`lib/services/ai_service.dart` 파일 열어서:
```dart
static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';
// ↑ 이 부분을 실제 Anthropic API 키로 교체
```

---

### 6단계: 실행!

**방법 A) Chrome 웹 브라우저로 실행 (권장)**
```bash
flutter run -d chrome
```

**방법 B) VSCode에서 F5 또는 Run 버튼**
- 우측 하단에서 기기 선택 (Chrome / Windows / 에뮬레이터)
- F5 또는 `실행 → 디버깅 시작`

**방법 C) 모바일 에뮬레이터**
- Android: Android Studio에서 에뮬레이터 시작 후 `flutter run`
- iOS (Mac 전용): Xcode에서 시뮬레이터 시작 후 `flutter run`

---

## 📅 매일 성경 본문 교체하는 방법

`assets/bible/john_3.txt` 파일 형식을 따라서 새 파일 추가:

```
요한복음 4장
1|사마리아 여자와 예수의 대화...
2|...
```

그 후 `pubspec.yaml`에 새 파일 경로 추가:
```yaml
flutter:
  assets:
    - assets/bible/john_3.txt
    - assets/bible/john_4.txt   ← 추가
```

`lib/screens/home_screen.dart`에서 경로 변경:
```dart
static const _assetPath = 'assets/bible/john_4.txt'; // ← 변경
```

---

## 🔑 핵심 파일 설명

| 파일 | 역할 |
|------|------|
| `main.dart` | 앱 시작점. `runApp()`이 Flutter를 실행함 |
| `pubspec.yaml` | 패키지 의존성, 폰트, assets 경로 설정 |
| `home_screen.dart` | 말씀 + 묵상 화면. 반응형(desktop/mobile) |
| `ai_service.dart` | Claude API 호출해서 묵상 질문 생성 |
| `bible_service.dart` | `.txt` 파일 읽어서 구절 목록으로 파싱 |

---

## 📱 반응형 동작

| 화면 너비 | 레이아웃 |
|-----------|----------|
| ≥ 1024px (데스크톱) | 좌: 성경본문 / 우: 묵상카드 분할 |
| < 1024px (태블릿·모바일) | PageView 슬라이드 (말씀 ↔ 묵상) |

사이드바는 항상 왼쪽에 고정됩니다.

---

## ⚠️ 주의사항

- **API 키 보안**: `ai_service.dart`의 API 키는 테스트용입니다.  
  실제 배포 시에는 서버(백엔드)에서 API를 호출하고,  
  클라이언트 코드에 API 키를 넣지 마세요.

- **웹 배포 시 CORS**: Anthropic API는 브라우저에서 직접 호출할 경우  
  CORS 오류가 날 수 있습니다. 이 경우 중간 프록시 서버가 필요합니다.
