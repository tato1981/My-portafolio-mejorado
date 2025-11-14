# Etapa de construcción
FROM node:20-alpine AS builder

WORKDIR /app

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

# Copiar solo lo necesario desde la etapa de construcción
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production

# Exponer el puerto
EXPOSE 4321

# Variable de entorno
ENV HOST=0.0.0.0
ENV PORT=4321

# Comando para iniciar la aplicación
CMD ["npm", "start"]
