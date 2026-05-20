import { useState, useEffect, useRef } from "react";

// ── 성경 본문 데이터 (요한복음 3장) ──────────────────────────────
const BIBLE_CHAPTERS = {
  "요한복음 3장": [
    { v: 1, t: "바리새인 중에 니고데모라 하는 사람이 있으니 유대인의 관리라" },
    { v: 2, t: "그가 밤에 예수께 와서 이르되 랍비여 우리가 당신은 하나님께로부터 오신 선생인 줄 아나이다 하나님이 함께 하시지 아니하시면 당신이 행하시는 이 표적을 아무도 할 수 없음이니이다" },
    { v: 3, t: "예수께서 대답하여 이르시되 진실로 진실로 네게 이르노니 사람이 거듭나지 아니하면 하나님의 나라를 볼 수 없느니라" },
    { v: 4, t: "니고데모가 이르되 사람이 늙으면 어떻게 날 수 있사옵나이까 두 번째 모태에 들어갔다가 날 수 있사옵나이까" },
    { v: 5, t: "예수께서 대답하시되 진실로 진실로 네게 이르노니 사람이 물과 성령으로 나지 아니하면 하나님의 나라에 들어갈 수 없느니라" },
    { v: 6, t: "육으로 난 것은 육이요 영으로 난 것은 영이니" },
    { v: 7, t: "내가 네게 거듭나야 하겠다 하는 말을 놀랍게 여기지 말라" },
    { v: 8, t: "바람이 임의로 불매 네가 그 소리는 들어도 어디서 와서 어디로 가는지 알지 못하나니 성령으로 난 사람도 다 그러하니라" },
    { v: 9, t: "니고데모가 대답하여 이르되 어찌 그러한 일이 있을 수 있나이까" },
    { v: 10, t: "예수께서 그에게 대답하여 이르시되 너는 이스라엘의 선생으로서 이러한 것들을 알지 못하느냐" },
    { v: 11, t: "진실로 진실로 네게 이르노니 우리는 아는 것을 말하고 본 것을 증언하노라 그러나 너희가 우리의 증언을 받지 아니하는도다" },
    { v: 12, t: "내가 땅의 일을 말하여도 너희가 믿지 아니하거든 하물며 하늘의 일을 말하면 어떻게 믿겠느냐" },
    { v: 13, t: "하늘에서 내려온 자 곧 인자 외에는 하늘에 올라간 자가 없느니라" },
    { v: 14, t: "모세가 광야에서 뱀을 든 것 같이 인자도 들려야 하리니" },
    { v: 15, t: "이는 그를 믿는 자마다 영생을 얻게 하려 하심이니라" },
    { v: 16, t: "하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니 이는 그를 믿는 자마다 멸망하지 않고 영생을 얻게 하려 하심이라" },
    { v: 17, t: "하나님이 그 아들을 세상에 보내신 것은 세상을 심판하려 하심이 아니요 그로 말미암아 세상이 구원을 받게 하려 하심이라" },
    { v: 18, t: "그를 믿는 자는 심판을 받지 아니하는 것이요 믿지 아니하는 자는 하나님의 독생자의 이름을 믿지 아니하므로 벌써 심판을 받은 것이니라" },
    { v: 19, t: "그 정죄는 이것이니 곧 빛이 세상에 왔으되 사람들이 자기 행위가 악하므로 빛보다 어둠을 더 사랑한 것이니라" },
    { v: 20, t: "악을 행하는 자마다 빛을 미워하여 빛으로 오지 아니하나니 이는 그 행위가 드러날까 함이요" },
    { v: 21, t: "진리를 따르는 자는 빛으로 오나니 이는 그 행위가 하나님 안에서 행한 것임을 나타내려 함이라 하시니라" },
    { v: 22, t: "그 후에 예수께서 제자들과 유대 땅으로 가서 거기 함께 유하시며 세례를 베푸시더라" },
    { v: 23, t: "요한도 살렘 가까운 애논에서 세례를 베푸니 거기 물이 많음이라 사람들이 와서 세례를 받더라" },
    { v: 24, t: "요한이 아직 옥에 갇히지 아니하였더라" },
    { v: 25, t: "이에 요한의 제자 중에서 한 유대인과 더불어 정결예식에 대하여 변론이 되었더니" },
    { v: 26, t: "그들이 요한에게 와서 이르되 랍비여 선생님과 함께 요단 강 저편에 있던 이 곧 선생님이 증언하시던 이가 세례를 베풀매 사람이 다 그에게로 가더이다" },
    { v: 27, t: "요한이 대답하여 이르되 만일 하늘에서 주신 바 아니면 사람이 아무것도 받을 수 없느니라" },
    { v: 28, t: "내가 말한 바 나는 그리스도가 아니요 그의 앞에 보내심을 받은 자라고 한 것을 증언할 자는 너희니라" },
    { v: 29, t: "신부를 취하는 자는 신랑이나 서서 신랑의 음성을 듣는 친구가 크게 기뻐하나니 나는 이러한 기쁨으로 충만하였노라" },
    { v: 30, t: "그는 흥하여야 하겠고 나는 쇠하여야 하리라 하니라" },
    { v: 31, t: "위로부터 오시는 이는 만물 위에 계시고 땅에서 난 이는 땅에 속하여 땅에 속한 것을 말하느니라 하늘로부터 오시는 이는 만물 위에 계시나니" },
    { v: 32, t: "그가 친히 보고 들은 것을 증언하되 그의 증언을 받는 자가 없도다" },
    { v: 33, t: "그의 증언을 받는 자는 하나님이 참되시다는 것에 인을 쳤느니라" },
    { v: 34, t: "하나님이 보내신 이는 하나님의 말씀을 하나니 이는 하나님이 성령을 한량없이 주심이니라" },
    { v: 35, t: "아버지께서 아들을 사랑하사 만물을 다 그의 손에 주셨으니" },
    { v: 36, t: "아들을 믿는 자에게는 영생이 있고 아들에게 순종하지 아니하는 자는 영생을 보지 못하고 도리어 하나님의 진노가 그 위에 머물러 있느니라" },
  ],
};

// ── 나눔 더미 데이터 ────────────────────────────────────────────
const SHARING_DATA = [
  {
    id: 1,
    name: "김지은",
    daysAgo: "2일 전",
    ref: "시편 23:1",
    verse: "여호와는 나의 목자시니 내게 부족함이 없으리로다",
    content: "오늘 하루도 주님께서 나의 목자가 되어주신다는 사실에 감사합니다. 아무것도 부족함이 없다는 확신 속에서...",
    highlight: "주님의 인도하심을 따르겠습니다",
    amen: 12,
  },
  {
    id: 2,
    name: "박성민",
    daysAgo: "3일 전",
    ref: "빌립보서 4:13",
    verse: "내게 능력 주시는 자 안에서 내가 모든 것을 할 수 있느니라",
    content: "오늘 어려운 프로젝트를 시작했는데, 이 말씀이 큰 힘이 되었습니다. 나의 힘이 아닌 주님의 능력으로...",
    highlight: "주님과 함께라면 두렵지 않아",
    amen: 8,
  },
  {
    id: 3,
    name: "이수진",
    daysAgo: "4일 전",
    ref: "요한복음 3:16",
    verse: "하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니",
    content: "하나님의 사랑의 깊이를 다시 한번 묵상했습니다. 그 사랑이 너무 크고 깊어서 감사한 마음이 넘칩니다...",
    highlight: "그 사랑을 나누며 살겠습니다",
    amen: 21,
  },
];

// ── 캘린더 데이터 ───────────────────────────────────────────────
const COMPLETED_DAYS = [1, 3, 4, 6, 7, 8, 10, 12, 13, 14];

// ── 색상 팔레트 ─────────────────────────────────────────────────
const C = {
  primary: "#1DB87A",
  primaryLight: "#E8F8F0",
  primaryMid: "#B2E8CE",
  text: "#1A2634",
  textMuted: "#6B7E8F",
  textLight: "#9BAEBF",
  bg: "#F4F7F5",
  card: "#FFFFFF",
  border: "#E5EDE9",
  sidebar: "#FFFFFF",
  verseNum: "#1DB87A",
};

// ── 아이콘 컴포넌트 ─────────────────────────────────────────────
const Icon = {
  Calendar: ({ active }) => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={active ? C.primary : C.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
      <line x1="16" y1="2" x2="16" y2="6"/>
      <line x1="8" y1="2" x2="8" y2="6"/>
      <line x1="3" y1="10" x2="21" y2="10"/>
    </svg>
  ),
  Users: ({ active }) => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={active ? C.primary : C.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
      <circle cx="9" cy="7" r="4"/>
      <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
      <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
    </svg>
  ),
  Home: ({ active }) => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke={active ? C.primary : C.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
      <polyline points="9 22 9 12 15 12 15 22"/>
    </svg>
  ),
  Type: () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={C.primary} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="4 7 4 4 20 4 20 7"/>
      <line x1="9" y1="20" x2="15" y2="20"/>
      <line x1="12" y1="4" x2="12" y2="20"/>
    </svg>
  ),
  Edit: () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={C.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
    </svg>
  ),
  Heart: ({ filled }) => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill={filled ? C.primary : "none"} stroke={C.primary} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
    </svg>
  ),
  Sparkle: () => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill={C.primary} stroke="none">
      <path d="M12 2l2.4 7.2H22l-6.2 4.5 2.4 7.3L12 16.5l-6.2 4.5 2.4-7.3L2 9.2h7.6L12 2z"/>
    </svg>
  ),
  ChevronLeft: () => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={C.textMuted} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="15 18 9 12 15 6"/>
    </svg>
  ),
  ChevronRight: () => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={C.textMuted} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="9 18 15 12 9 6"/>
    </svg>
  ),
  Loader: () => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={C.primary} strokeWidth="2.5" strokeLinecap="round">
      <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83">
        <animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="1s" repeatCount="indefinite"/>
      </path>
    </svg>
  ),
};

// ── AI 질문 생성 ────────────────────────────────────────────────
async function generateQTQuestions(chapterTitle, verses) {
  const verseText = verses.slice(0, 10).map(v => `${v.v}절: ${v.t}`).join("\n");
  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      model: "claude-sonnet-4-20250514",
      max_tokens: 500,
      messages: [{
        role: "user",
        content: `다음 성경 본문(${chapterTitle})을 바탕으로 QT(묵상) 질문 3개를 만들어주세요.\n\n${verseText}\n\n규칙:\n- 짧고 명확하게 (한 문장씩)\n- 개인의 삶과 연결되는 질문\n- 번호 없이 각 줄에 하나씩\n- JSON 배열로만 응답: ["질문1", "질문2", "질문3"]`
      }]
    })
  });
  const data = await response.json();
  const text = data.content?.[0]?.text || "";
  try {
    const clean = text.replace(/```json|```/g, "").trim();
    return JSON.parse(clean);
  } catch {
    return [
      "하나님의 사랑이 내 삶에서 어떻게 나타나고 있나요?",
      "영생을 얻는다는 것이 오늘 내게 어떤 의미인가요?",
      "이 말씀을 통해 누군가에게 전하고 싶은 것은 무엇인가요?",
    ];
  }
}

// ══════════════════════════════════════════════════════════════
// 메인 앱
// ══════════════════════════════════════════════════════════════
export default function App() {
  const [activeNav, setActiveNav] = useState("home");
  const [questions, setQuestions] = useState([
    "하나님의 사랑이 내 삶에서 어떻게 나타나고 있나요?",
    "영생을 얻는다는 것이 오늘 내게 어떤 의미인가요?",
    "이 말씀을 통해 누군가에게 전하고 싶은 것은 무엇인가요?",
  ]);
  const [loadingQ, setLoadingQ] = useState(false);
  const [meditation, setMeditation] = useState("");
  const [amedMap, setAmedMap] = useState({});
  const [calMonth, setCalMonth] = useState({ year: 2026, month: 5 });

  const chapterKey = "요한복음 3장";
  const verses = BIBLE_CHAPTERS[chapterKey];

  const handleGenerateQ = async () => {
    setLoadingQ(true);
    try {
      const q = await generateQTQuestions(chapterKey, verses);
      setQuestions(q);
    } catch {
      /* keep defaults */
    } finally {
      setLoadingQ(false);
    }
  };

  const toggleAmen = (id) => setAmedMap(p => ({ ...p, [id]: !p[id] }));

  return (
    <div style={{ display: "flex", height: "100vh", background: C.bg, fontFamily: "'Noto Sans KR', sans-serif", overflow: "hidden" }}>
      {/* ── Google Fonts ── */}
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; }
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: ${C.primaryMid}; border-radius: 2px; }
        textarea { resize: none; font-family: 'Noto Sans KR', sans-serif; }
        @keyframes spin { to { transform: rotate(360deg); } }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
        .nav-btn { transition: all 0.18s ease; }
        .nav-btn:hover { background: ${C.primaryLight} !important; }
        .amen-btn:hover { opacity: 0.8; }
        .verse-row:hover .verse-num { color: ${C.primary} !important; }
        .card-hover { transition: box-shadow 0.2s ease; }
        .card-hover:hover { box-shadow: 0 4px 20px rgba(29,184,122,0.12) !important; }
      `}</style>

      {/* ══ SIDEBAR ══════════════════════════════════════════════ */}
      <Sidebar active={activeNav} setActive={setActiveNav} />

      {/* ══ MAIN CONTENT ═════════════════════════════════════════ */}
      <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>
        {activeNav === "home" && (
          <HomeView
            chapterKey={chapterKey}
            verses={verses}
            questions={questions}
            loadingQ={loadingQ}
            meditation={meditation}
            setMeditation={setMeditation}
            onGenerateQ={handleGenerateQ}
          />
        )}
        {activeNav === "sharing" && (
          <SharingView data={SHARING_DATA} amedMap={amedMap} toggleAmen={toggleAmen} />
        )}
        {activeNav === "calendar" && (
          <CalendarView completed={COMPLETED_DAYS} month={calMonth} setMonth={setCalMonth} />
        )}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// SIDEBAR
// ══════════════════════════════════════════════════════════════
function Sidebar({ active, setActive }) {
  const navItems = [
    { key: "calendar", IconComp: Icon.Calendar, label: "캘린더" },
    { key: "sharing", IconComp: Icon.Users, label: "나눔" },
    { key: "home", IconComp: Icon.Home, label: "홈" },
  ];

  return (
    <div style={{
      width: 64, background: C.sidebar, borderRight: `1px solid ${C.border}`,
      display: "flex", flexDirection: "column", alignItems: "center",
      paddingTop: 24, gap: 8, flexShrink: 0,
    }}>
      {navItems.map(({ key, IconComp, label }) => (
        <button
          key={key}
          className="nav-btn"
          onClick={() => setActive(key)}
          title={label}
          style={{
            width: 44, height: 44, borderRadius: 12, border: "none", cursor: "pointer",
            background: active === key ? C.primaryLight : "transparent",
            display: "flex", alignItems: "center", justifyContent: "center",
          }}
        >
          <IconComp active={active === key} />
        </button>
      ))}
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// HOME VIEW
// ══════════════════════════════════════════════════════════════
function HomeView({ chapterKey, verses, questions, loadingQ, meditation, setMeditation, onGenerateQ }) {
  return (
    <div style={{ flex: 1, display: "flex", overflow: "hidden" }}>
      {/* ── 성경 본문 ── */}
      <div style={{
        flex: 1, overflowY: "auto", padding: "32px 40px",
        borderRight: `1px solid ${C.border}`,
      }}>
        <p style={{ fontSize: 13, fontWeight: 600, color: C.primary, marginBottom: 24, letterSpacing: "0.05em" }}>
          {chapterKey}
        </p>
        <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
          {verses.map((v) => (
            <div key={v.v} className="verse-row" style={{ display: "flex", gap: 16, alignItems: "flex-start" }}>
              <span className="verse-num" style={{
                fontSize: 13, fontWeight: 700, color: C.verseNum,
                minWidth: 20, paddingTop: 2, transition: "color 0.15s",
              }}>{v.v}</span>
              <p style={{ fontSize: 15, lineHeight: 1.8, color: C.text, fontWeight: 400 }}>{v.t}</p>
            </div>
          ))}
        </div>
      </div>

      {/* ── 오른쪽 카드 영역 ── */}
      <div style={{
        width: 340, overflowY: "auto", padding: "32px 24px",
        display: "flex", flexDirection: "column", gap: 16,
        background: C.bg,
      }}>
        {/* 오늘의 묵상 질문 카드 */}
        <div className="card-hover" style={{
          background: C.card, borderRadius: 16, padding: 24,
          boxShadow: "0 1px 6px rgba(0,0,0,0.06)", border: `1px solid ${C.border}`,
        }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 16 }}>
            <p style={{ fontSize: 15, fontWeight: 700, color: C.text }}>오늘의 묵상 질문</p>
            <button
              onClick={onGenerateQ}
              disabled={loadingQ}
              style={{
                display: "flex", alignItems: "center", gap: 4,
                fontSize: 11, fontWeight: 600, color: C.primary,
                background: C.primaryLight, border: "none", borderRadius: 20,
                padding: "4px 10px", cursor: "pointer",
              }}
            >
              {loadingQ ? <Icon.Loader /> : <Icon.Sparkle />}
              {loadingQ ? "생성 중..." : "AI 재생성"}
            </button>
          </div>
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            {questions.map((q, i) => (
              <div key={i} style={{ display: "flex", gap: 10, alignItems: "flex-start", animation: "fadeIn 0.3s ease both", animationDelay: `${i * 0.08}s` }}>
                <span style={{
                  fontSize: 12, fontWeight: 700, color: C.primary,
                  background: C.primaryLight, borderRadius: "50%",
                  width: 20, height: 20, display: "flex", alignItems: "center", justifyContent: "center",
                  flexShrink: 0, marginTop: 1,
                }}>{i + 1}</span>
                <p style={{ fontSize: 13, lineHeight: 1.65, color: C.text }}>{q}</p>
              </div>
            ))}
          </div>
        </div>

        {/* 나의 묵상 카드 */}
        <div className="card-hover" style={{
          background: C.card, borderRadius: 16, padding: 24,
          boxShadow: "0 1px 6px rgba(0,0,0,0.06)", border: `1px solid ${C.border}`,
          flex: 1, display: "flex", flexDirection: "column",
        }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 14 }}>
            <p style={{ fontSize: 15, fontWeight: 700, color: C.text }}>나의 묵상</p>
            <div style={{ display: "flex", gap: 8 }}>
              <button style={{ background: "none", border: "none", cursor: "pointer", padding: 4, borderRadius: 6, display: "flex" }}>
                <Icon.Type />
              </button>
              <button style={{ background: "none", border: "none", cursor: "pointer", padding: 4, borderRadius: 6, display: "flex" }}>
                <Icon.Edit />
              </button>
            </div>
          </div>
          <textarea
            value={meditation}
            onChange={e => setMeditation(e.target.value)}
            placeholder="이 말씀을 묵상하며 떠오른 생각들을 자유롭게 적어보세요..."
            style={{
              flex: 1, minHeight: 200, width: "100%", border: "none",
              fontSize: 13, lineHeight: 1.75, color: C.text,
              background: "transparent", outline: "none",
              placeholder_color: C.textLight,
            }}
          />
          {meditation && (
            <div style={{ marginTop: 12, paddingTop: 12, borderTop: `1px solid ${C.border}` }}>
              <button
                style={{
                  width: "100%", padding: "10px 0",
                  background: C.primary, color: "#fff",
                  border: "none", borderRadius: 10,
                  fontSize: 13, fontWeight: 600, cursor: "pointer",
                  transition: "opacity 0.18s",
                }}
                onMouseOver={e => e.target.style.opacity = "0.88"}
                onMouseOut={e => e.target.style.opacity = "1"}
              >
                묵상 저장하기
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// SHARING VIEW
// ══════════════════════════════════════════════════════════════
function SharingView({ data, amedMap, toggleAmen }) {
  return (
    <div style={{ flex: 1, overflowY: "auto", padding: "40px 80px" }}>
      <h2 style={{ fontSize: 24, fontWeight: 700, color: C.text, marginBottom: 28 }}>나눔</h2>
      <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
        {data.map(item => (
          <div key={item.id} className="card-hover" style={{
            background: C.card, borderRadius: 16, padding: 28,
            boxShadow: "0 1px 6px rgba(0,0,0,0.06)", border: `1px solid ${C.border}`,
            animation: "fadeIn 0.3s ease both",
          }}>
            {/* Header */}
            <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 14 }}>
              <div style={{
                width: 36, height: 36, borderRadius: "50%",
                background: C.primary, color: "#fff",
                display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 14, fontWeight: 700,
              }}>{item.name[0]}</div>
              <div>
                <p style={{ fontSize: 14, fontWeight: 600, color: C.text }}>{item.name}</p>
                <p style={{ fontSize: 11, color: C.textLight }}>{item.daysAgo}</p>
              </div>
            </div>
            {/* Ref */}
            <p style={{ fontSize: 11, fontWeight: 600, color: C.primary, marginBottom: 6, letterSpacing: "0.03em" }}>{item.ref}</p>
            {/* Verse */}
            <p style={{ fontSize: 16, fontWeight: 600, color: C.text, marginBottom: 10, lineHeight: 1.5 }}>{item.verse}</p>
            {/* Content */}
            <p style={{ fontSize: 13, color: C.textMuted, lineHeight: 1.7, marginBottom: 14 }}>{item.content}</p>
            {/* Highlight */}
            <div style={{
              background: C.primaryLight, borderRadius: 10, padding: "12px 16px",
              fontSize: 13, fontWeight: 500, color: C.primary, marginBottom: 16, textAlign: "center",
            }}>{item.highlight}</div>
            {/* Amen */}
            <button
              className="amen-btn"
              onClick={() => toggleAmen(item.id)}
              style={{
                display: "flex", alignItems: "center", gap: 6,
                background: "none", border: "none", cursor: "pointer",
                fontSize: 13, fontWeight: 500,
                color: amedMap[item.id] ? C.primary : C.textMuted,
                padding: 0,
              }}
            >
              <Icon.Heart filled={amedMap[item.id]} />
              아멘 {item.amen + (amedMap[item.id] ? 1 : 0)}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

// ══════════════════════════════════════════════════════════════
// CALENDAR VIEW
// ══════════════════════════════════════════════════════════════
function CalendarView({ completed, month, setMonth }) {
  const { year, month: m } = month;
  const DAYS = ["일", "월", "화", "수", "목", "금", "토"];

  const firstDay = new Date(year, m - 1, 1).getDay();
  const daysInMonth = new Date(year, m, 0).getDate();

  const cells = [];
  for (let i = 0; i < firstDay; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);

  const prevMonth = () => setMonth(prev => {
    if (prev.month === 1) return { year: prev.year - 1, month: 12 };
    return { ...prev, month: prev.month - 1 };
  });
  const nextMonth = () => setMonth(prev => {
    if (prev.month === 12) return { year: prev.year + 1, month: 1 };
    return { ...prev, month: prev.month + 1 };
  });

  return (
    <div style={{ flex: 1, display: "flex", alignItems: "center", justifyContent: "center", padding: 40 }}>
      <div style={{
        background: C.card, borderRadius: 20, padding: "32px 40px",
        boxShadow: "0 2px 16px rgba(0,0,0,0.07)", border: `1px solid ${C.border}`,
        width: "100%", maxWidth: 560,
      }}>
        {/* Header */}
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 28 }}>
          <button onClick={prevMonth} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", padding: 4 }}>
            <Icon.ChevronLeft />
          </button>
          <p style={{ fontSize: 18, fontWeight: 700, color: C.text }}>{year}년 {m}월</p>
          <button onClick={nextMonth} style={{ background: "none", border: "none", cursor: "pointer", display: "flex", padding: 4 }}>
            <Icon.ChevronRight />
          </button>
        </div>

        {/* Day headers */}
        <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 8, marginBottom: 12 }}>
          {DAYS.map(d => (
            <div key={d} style={{ textAlign: "center", fontSize: 13, fontWeight: 600, color: C.textLight, padding: "4px 0" }}>{d}</div>
          ))}
        </div>

        {/* Day cells */}
        <div style={{ display: "grid", gridTemplateColumns: "repeat(7, 1fr)", gap: 8 }}>
          {cells.map((day, i) => {
            if (!day) return <div key={`empty-${i}`} />;
            const done = completed.includes(day);
            return (
              <div key={day} style={{
                aspectRatio: "1", borderRadius: 12,
                background: done ? C.primary : "#F0F4F2",
                display: "flex", alignItems: "center", justifyContent: "center",
                cursor: "pointer", transition: "all 0.18s ease",
              }}
                onMouseOver={e => { if (!done) e.currentTarget.style.background = C.primaryLight; }}
                onMouseOut={e => { if (!done) e.currentTarget.style.background = "#F0F4F2"; }}
              >
                <span style={{ fontSize: 14, fontWeight: 600, color: done ? "#fff" : C.textMuted }}>{day}</span>
              </div>
            );
          })}
        </div>

        {/* Legend */}
        <div style={{ display: "flex", justifyContent: "center", gap: 24, marginTop: 24, paddingTop: 20, borderTop: `1px solid ${C.border}` }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <div style={{ width: 12, height: 12, borderRadius: 3, background: C.primary }} />
            <span style={{ fontSize: 12, color: C.textMuted }}>묵상 완료</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <div style={{ width: 12, height: 12, borderRadius: 3, background: "#F0F4F2", border: `1px solid ${C.border}` }} />
            <span style={{ fontSize: 12, color: C.textMuted }}>묵상 없음</span>
          </div>
        </div>
      </div>
    </div>
  );
}
