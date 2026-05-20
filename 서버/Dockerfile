# 1. Node.js 가벼운 버전(Alpine)을 베이스 이미지로 사용
FROM node:20-alpine

# 2. 컨테이너 내부의 작업 디렉토리 설정
WORKDIR /app

# 3. 패키지 설치를 위해 package.json과 package-lock.json 복사
COPY package*.json ./

# 4. 필수 패키지 설치 (배포용이므로 프로덕션 모드로 설치)
RUN npm install --production

# 5. 나머지 소스 코드 파일을 컨테이너 내부로 전부 복사
COPY . .

# 6. 사용자님이 지정하신 1225 포트를 외부로 개방
EXPOSE 1225

# 7. 서버 시작 명령어 실행
CMD ["node", "index.js"]