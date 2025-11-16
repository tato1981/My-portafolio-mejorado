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

### 3. Variables de Entorno (IMPORTANTE)

Debes configurar estas variables de entorno en Dokploy antes del despliegue:

#### Variables Obligatorias:

```bash
# Información Personal
PUBLIC_NAME=Tu Nombre Completo
PUBLIC_EMAIL=tu@email.com
PUBLIC_PHONE=+57 123456789
PUBLIC_LOCATION=Tu Ciudad, País

# Redes Sociales
PUBLIC_GITHUB_URL=https://github.com/tu-usuario
PUBLIC_LINKEDIN_URL=https://linkedin.com/in/tu-usuario
PUBLIC_YOUTUBE_URL=https://youtube.com/tu-canal
PUBLIC_TWITTER_URL=https://x.com/tu-usuario
PUBLIC_INSTAGRAM_URL=https://instagram.com/tu-usuario

# Títulos Profesionales
PUBLIC_TITLE_1=Tu Primer Título
PUBLIC_TITLE_2=Tu Segundo Título
PUBLIC_TITLE_3=Tu Tercer Título

# URLs de Certificaciones
PUBLIC_CERT_CERTJOIN_URL=https://url-certificacion-1.com
PUBLIC_CERT_HACKING_URL=https://url-certificacion-2.com
PUBLIC_CERT_SENATEC_URL=https://url-certificacion-3.com
```

#### Variables del Servidor (opcionales):

```bash
HOST=0.0.0.0
PORT=4321
NODE_ENV=production
```

**💡 Tip**: Puedes copiar el contenido de `.env.example` y ajustar los valores.

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
