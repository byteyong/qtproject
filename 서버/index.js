require('dotenv').config();

const express = require('express');
const cors = require('cors');
//const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 1225;
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');

const DUMMY_BIBLE = { /* 성경 데이터 */ };
const userMeditations = [];

app.use(cors());
app.use(express.json());

// 💡 DB 커넥션 풀 설정 (본인의 DB 정보에 맞게 수정하세요)
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

// 1. 회원가입 라우터 (DB 연동 및 비밀번호 암호화 적용)
app.post('/api/auth/signup', async (req, res) => {
  const { email, password, nickname } = req.body; // nickname 추가

  if (!email || !password || !nickname) {
    return res.status(400).json({ message: "이메일, 닉네임, 비밀번호를 모두 입력해주세요." });
  }

  try {
    const [existingUsers] = await pool.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (existingUsers.length > 0) {
      return res.status(409).json({ message: "이미 존재하는 이메일입니다." });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // password → password_hash, nickname 추가
    await pool.execute(
      'INSERT INTO users (email, password_hash, nickname) VALUES (?, ?, ?)',
      [email, hashedPassword, nickname]
    );

    return res.status(201).json({ message: "회원가입이 완료되었습니다." });
  } catch (error) {
    console.error("회원가입 오류:", error);
    return res.status(500).json({ message: "서버 오류로 회원가입에 실패했습니다." });
  }
});

// 2. 로그인 라우터 (DB 조회 및 비밀번호 검증)
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "이메일과 비밀번호를 모두 입력해주세요." });
  }

  try {
    // 2-1. DB에서 유저 조회
    const [users] = await pool.execute(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({ message: "이메일 또는 비밀번호가 올바르지 않습니다." });
    }

    const user = users[0];

    // 2-2. 비밀번호 일치 여부 검증 (입력된 비밀번호 vs DB의 암호화된 비밀번호)
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);

    if (!isPasswordValid) {
      return res.status(401).json({ message: "이메일 또는 비밀번호가 올바르지 않습니다." });
    }

    // 2-3. 로그인 성공 응답
    return res.status(200).json({
      message: "로그인 성공",
      token: "mock-jwt-token-xyz", // 실제 운영 시 jsonwebtoken(JWT) 패키지를 사용해 발급
      user: { id: user.id, email: user.email }
    });
  } catch (error) {
    console.error("로그인 오류:", error);
    return res.status(500).json({ message: "서버 오류로 로그인에 실패했습니다." });
  }
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