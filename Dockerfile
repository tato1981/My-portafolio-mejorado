# Dockerfile multi-stage para Astro con Nginx
# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

# Remover configuración default
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos estáticos
COPY --from=builder /app/dist /usr/share/nginx/html

# Dar permisos correctos
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
