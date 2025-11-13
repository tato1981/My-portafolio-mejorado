# Dockerfile multi-stage para Astro con Nginx
# Stage 1: Build
FROM node:20-alpine AS builder

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production=false

# Copiar el resto del código
COPY . .

# Construir la aplicación
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

# Copiar configuración personalizada de Nginx (si existe)
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos estáticos desde el stage de build
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer puerto 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
