FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY src/ ./src/

EXPOSE 3004

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3004/health || exit 1

CMD ["node", "src/index.js"]
