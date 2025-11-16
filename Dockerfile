# Etapa de construcción
FROM node:20-alpine AS builder

WORKDIR /app

# Argumentos de build para variables de entorno públicas
ARG PUBLIC_NAME
ARG PUBLIC_EMAIL
ARG PUBLIC_PHONE
ARG PUBLIC_LOCATION
ARG PUBLIC_GITHUB_URL
ARG PUBLIC_LINKEDIN_URL
ARG PUBLIC_YOUTUBE_URL
ARG PUBLIC_TWITTER_URL
ARG PUBLIC_INSTAGRAM_URL
ARG PUBLIC_TITLE_1
ARG PUBLIC_TITLE_2
ARG PUBLIC_TITLE_3
ARG PUBLIC_CERT_CERTJOIN_URL
ARG PUBLIC_CERT_HACKING_URL
ARG PUBLIC_CERT_SENATEC_URL

# Exportar como variables de entorno para el build
ENV PUBLIC_NAME=$PUBLIC_NAME \
    PUBLIC_EMAIL=$PUBLIC_EMAIL \
    PUBLIC_PHONE=$PUBLIC_PHONE \
    PUBLIC_LOCATION=$PUBLIC_LOCATION \
    PUBLIC_GITHUB_URL=$PUBLIC_GITHUB_URL \
    PUBLIC_LINKEDIN_URL=$PUBLIC_LINKEDIN_URL \
    PUBLIC_YOUTUBE_URL=$PUBLIC_YOUTUBE_URL \
    PUBLIC_TWITTER_URL=$PUBLIC_TWITTER_URL \
    PUBLIC_INSTAGRAM_URL=$PUBLIC_INSTAGRAM_URL \
    PUBLIC_TITLE_1=$PUBLIC_TITLE_1 \
    PUBLIC_TITLE_2=$PUBLIC_TITLE_2 \
    PUBLIC_TITLE_3=$PUBLIC_TITLE_3 \
    PUBLIC_CERT_CERTJOIN_URL=$PUBLIC_CERT_CERTJOIN_URL \
    PUBLIC_CERT_HACKING_URL=$PUBLIC_CERT_HACKING_URL \
    PUBLIC_CERT_SENATEC_URL=$PUBLIC_CERT_SENATEC_URL

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci

# Copiar el resto del código
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:20-alpine AS runtime

WORKDIR /app

# Instalar dependencias mínimas de producción primero
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copiar solo los archivos construidos desde la etapa de construcción
COPY --from=builder /app/dist ./dist

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

# Cambiar a usuario no-root
USER nodejs

# Exponer el puerto
EXPOSE 4321

# Variables de entorno
ENV HOST=0.0.0.0
ENV PORT=4321
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4321', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Comando para iniciar la aplicación
CMD ["npm", "start"]
