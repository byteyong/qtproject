const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 3000;

// 미들웨어 설정
app.use(cors());
app.use(express.json());

// 임시 인메모리 데이터베이스 (실제 운영시에는 DB 모델 연결)
let userMeditations = [];

// 더미 성경 데이터 백업본
const DUMMY_BIBLE = {
  title: "요한복음 3장",
  verses: [
    { id: 1, text: "바리새인 중에 니고데모라 하는 사람이 있으니 유대인의 관리라" },
    { id: 2, text: "그가 밤에 예수께 와서 이르되 랍비여 우리가 당신은 하나님께로부터 오신 선생인 줄 아나이다" },
    { id: 16, text: "하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니 이는 그를 믿는 자마다 멸망하지 않고 영생을 얻게 하려 하심이라" }
  ]
};

// 1. 로그인 라우터
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  // 단순 검증 예시 (필요에 따라 암호화 및 DB 검증 추가)
  if (!email || !password) {
    return res.status(400).json({ message: "이메일과 비밀번호를 모두 입력해주세요." });
  }

  // 로그인 성공 응답 (간단한 토큰 세션 반환)
  return res.status(200).json({
    message: "로그인 성공",
    token: "mock-jwt-token-xyz",
    user: { email: email }
  });
});

// 2. 성경 데이터 제공 라우터
app.get('/api/bible/chapter', (req, res) => {
  try {
    // 실제 파일 시스템 읽기나 DB 연동 가능 기본 제공 영역
    return res.status(200).json(DUMMY_BIBLE);
  } catch (error) {
    return res.status(500).json({ message: "성경 데이터를 불러오는 데 실패했습니다." });
  }
});

// 3. AI 질문 데이터 수신 및 프록시 라우터
app.post('/api/ai/questions', async (req, res) => {
  const { chapterTitle, verseTexts } = req.body;

  if (!verseTexts || verseTexts.length === 0) {
    return res.status(400).json({ message: "질문을 구성할 본문 텍스트가 필요합니다." });
  }

  try {
    // 외부 AI 서비스 API 호출 (예시: Anthropic Claude 혹은 OpenAI 인티그레이션 인프라 공간)
    // 현재는 API 키가 없거나 외부 통신이 차단될 수 있으므로 폴백(Fallback) 교육용 데이터를 기본 제공합니다.
    const mockAiQuestions = [
      `${chapterTitle} 말씀 속 니고데모의 모습을 보며 내 신앙의 태도는 어떤지 돌아봅시다.`,
      `오늘 본문 중 가장 마음을 강하게 울린 절은 무엇이며, 그 이유는 무엇인가요?`,
      `하나님이 주신 구원의 기쁨을 오늘 내 주변의 누구와 나누고 싶습니까?`
    ];

    return res.status(200).json({ questions: mockAiQuestions });
  } catch (error) {
    return res.status(500).json({ message: "AI 분석 결과를 생성하는 도중 오류가 발생했습니다." });
  }
});

// 4. 묵상 데이터 저장 라우터
app.post('/api/meditation', (req, res) => {
  const { content, chapterTitle, date } = req.body;

  if (!content) {
    return res.status(400).json({ message: "묵상 내용을 입력해주세요." });
  }

  const newMeditation = {
    id: userMeditations.length + 1,
    content,
    chapterTitle: chapterTitle || "요한복음 3장",
    date: date || new Date().toISOString()
  };

  userMeditations.push(newMeditation);
  return res.status(200).json({ message: "묵상이 성공적으로 저장되었습니다.", data: newMeditation });
});

// 5. 묵상 데이터 조회 라우터
app.get('/api/meditation', (req, res) => {
  // 전체 저장된 데이터 역순 반환 (최신 글이 먼저 오도록)
  return res.status(200).json({ meditations: [...userMeditations].reverse() });
});

// 헬스체크 라우터
app.get('/', (req, res) => {
  res.send('성경 QT 프로젝트 API 백엔드 서버가 안정적으로 구동 중입니다.');
});

app.listen(PORT, () => {
  console.log(`[서버 구동] 주소: http://localhost:${PORT}`);
});