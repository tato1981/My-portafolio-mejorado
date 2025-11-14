# Despliegue en Dokploy

Este portafolio está configurado para desplegarse en Dokploy usando Docker.

## 🚀 Configuración en Dokploy

### 1. Crear Nueva Aplicación

1. En tu panel de Dokploy, crea una nueva aplicación
2. Conecta tu repositorio Git o sube el código

### 2. Configuración del Proyecto

- **Puerto**: 4321
- **Build Command**: Automático (usa Dockerfile)
- **Start Command**: Automático (definido en Dockerfile)

### 3. Variables de Entorno (Opcionales)

```
HOST=0.0.0.0
PORT=4321
```

### 4. Desplegar

Dokploy automáticamente:
- Construirá la imagen Docker
- Desplegará el contenedor
- Expondrá la aplicación en el puerto configurado

## 📦 Archivos de Configuración

- **Dockerfile**: Define la imagen de producción optimizada con multi-stage build
- **.dockerignore**: Excluye archivos innecesarios del build

## 🔧 Comandos Locales

```bash
# Desarrollo local
npm run dev

# Construir para producción
npm run build

# Preview local
npm run preview

# Construir Docker localmente (opcional)
docker build -t portafolio .
docker run -p 4321:4321 portafolio
```

## ✨ Características

- Build optimizado con multi-stage Docker
- Imagen ligera basada en Alpine Linux
- Solo dependencias de producción en runtime
- Puerto configurable vía variables de entorno
