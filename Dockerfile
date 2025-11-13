# Dockerfile multi-stage para Astro con Nginx
# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --legacy-peer-deps

COPY . .
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

# Remover configuración default
RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/nginx.conf

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos estáticos
COPY --from=builder /app/dist /usr/share/nginx/html

# Dar permisos correctos
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html

# Verificar que la configuración de Nginx es válida
RUN nginx -t

EXPOSE 80

# Healthcheck para asegurar que Nginx está funcionando
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
