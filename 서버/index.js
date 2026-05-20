// index.js
const express = require('express');
const cors = require('cors');
const pool = require('./db'); // 방금 만든 안전한 DB 연결 모듈 가져오기
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 1225;

// 미들웨어 세팅
app.use(cors()); // Flutter 웹앱의 API 접근을 허용
app.use(express.json()); // JSON 형식의 본문(Body) 데이터를 읽을 수 있게 함

// 기본 라우트 테스트 (웹 브라우저에서 서버 정상 작동 여부 확인용)
app.get('/', (req, res) => {
  res.send('성경 읽기 앱 백엔드 서버가 정상 동작 중입니다! 📖✨');
});

// [테스트 API] 성경 데이터 가져오기 예시 맛보기
app.get('/api/bible/test', async (req, res) => {
  try {
    // bibles 테이블에서 샘플로 5개 구절만 조회해보기
    const [rows] = await pool.query('SELECT * FROM bibles LIMIT 5');
    res.json({ success: true, data: rows });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// 서버 시작
app.listen(PORT, () => {
  console.log(`🚀 서버가 포트 ${PORT}에서 작동 중입니다!`);
});