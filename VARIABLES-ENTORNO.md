# 🔐 Guía de Variables de Entorno

Este proyecto utiliza variables de entorno para personalizar toda la información que aparece en el portafolio.

## 📋 Variables Disponibles

### 👤 Información Personal

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `PUBLIC_NAME` | Tu nombre completo | `Duberney Obando Cano` |
| `PUBLIC_EMAIL` | Tu correo electrónico | `tu@email.com` |
| `PUBLIC_PHONE` | Tu número de teléfono | `+57 3145716188` |
| `PUBLIC_LOCATION` | Tu ubicación | `Colombia` |

### 🌐 Redes Sociales

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `PUBLIC_GITHUB_URL` | URL de tu perfil de GitHub | `https://github.com/usuario` |
| `PUBLIC_LINKEDIN_URL` | URL de tu perfil de LinkedIn | `https://linkedin.com/in/usuario` |
| `PUBLIC_YOUTUBE_URL` | URL de tu canal de YouTube | `https://youtube.com/usuario` |
| `PUBLIC_TWITTER_URL` | URL de tu perfil de X/Twitter | `https://x.com/usuario` |
| `PUBLIC_INSTAGRAM_URL` | URL de tu perfil de Instagram | `https://instagram.com/usuario` |

### 💼 Títulos Profesionales

Estos títulos aparecen en el efecto typewriter del Hero:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `PUBLIC_TITLE_1` | Primer título profesional | `Tecnólogo en Desarrollo` |
| `PUBLIC_TITLE_2` | Segundo título profesional | `Desarrollador Full Stack` |
| `PUBLIC_TITLE_3` | Tercer título profesional | `Especialista en Seguridad` |

### 🎓 Certificaciones

URLs de tus certificaciones verificables:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `PUBLIC_CERT_CERTJOIN_URL` | URL certificación CertJoin | `https://cert.com/verify` |
| `PUBLIC_CERT_HACKING_URL` | URL certificación Hacking | `https://cert2.com/verify` |
| `PUBLIC_CERT_SENATEC_URL` | URL certificación Senatec | `https://cert3.com/verify` |

### ⚙️ Configuración del Servidor

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `HOST` | Host del servidor | `0.0.0.0` |
| `PORT` | Puerto del servidor | `4321` |
| `NODE_ENV` | Entorno de ejecución | `production` |

## 🚀 Uso en Desarrollo Local

### 1. Crear archivo `.env`

Copia el archivo `.env.example` a `.env`:

```bash
cp .env.example .env
```

### 2. Editar valores

Abre el archivo `.env` y personaliza los valores:

```env
PUBLIC_NAME=Tu Nombre
PUBLIC_EMAIL=tu@email.com
PUBLIC_PHONE=+57 123456789
# ... etc
```

### 3. Ejecutar proyecto

```bash
npm run dev
```

Las variables se cargarán automáticamente.

## 🐳 Uso en Dokploy

### Opción 1: Variables de Entorno en la UI

1. Ve a tu aplicación en Dokploy
2. Navega a la sección **Environment Variables**
3. Añade cada variable una por una:
   - **Name**: `PUBLIC_NAME`
   - **Value**: `Tu Nombre`
   - Click **Add**
4. Repite para todas las variables
5. Guarda y redespliega

### Opción 2: Build Arguments (Recomendado)

En la configuración de build de Dokploy, añade los build arguments:

```dockerfile
PUBLIC_NAME=Tu Nombre
PUBLIC_EMAIL=tu@email.com
PUBLIC_PHONE=+57 123456789
PUBLIC_LOCATION=Colombia
PUBLIC_GITHUB_URL=https://github.com/usuario
PUBLIC_LINKEDIN_URL=https://linkedin.com/in/usuario
PUBLIC_YOUTUBE_URL=https://youtube.com/usuario
PUBLIC_TWITTER_URL=https://x.com/usuario
PUBLIC_INSTAGRAM_URL=https://instagram.com/usuario
PUBLIC_TITLE_1=Título 1
PUBLIC_TITLE_2=Título 2
PUBLIC_TITLE_3=Título 3
PUBLIC_CERT_CERTJOIN_URL=https://cert1.com
PUBLIC_CERT_HACKING_URL=https://cert2.com
PUBLIC_CERT_SENATEC_URL=https://cert3.com
```

### Opción 3: Archivo .env en el Repositorio

⚠️ **No recomendado para datos sensibles**, pero válido para información pública:

1. Crea un archivo `.env` en la raíz del proyecto
2. Añade las variables
3. Haz commit y push
4. Dokploy las leerá automáticamente

## 🔒 Seguridad

### Variables Públicas vs Privadas

- **`PUBLIC_*`**: Estas variables son **públicas** y se incluyen en el código JavaScript del cliente
- Solo usa `PUBLIC_*` para información que quieres que sea visible en el navegador
- Nunca pongas API keys secretas en variables `PUBLIC_*`

### Ejemplo Seguro vs Inseguro

✅ **SEGURO** (información pública):
```env
PUBLIC_NAME=Juan Pérez
PUBLIC_EMAIL=contacto@ejemplo.com
PUBLIC_GITHUB_URL=https://github.com/juan
```

❌ **INSEGURO** (nunca hagas esto):
```env
# NO uses variables PUBLIC_ para datos sensibles
PUBLIC_API_SECRET=xxxxxxxx         # ¡Nunca!
PUBLIC_DATABASE_PASS=xxxxxxxx      # ¡Nunca!
```

## 🧪 Testing

### Verificar variables cargadas

Ejecuta el build y verifica que las variables se incorporan:

```bash
npm run build
```

### Verificar en el navegador

1. Ejecuta `npm run preview`
2. Abre http://localhost:4321
3. Verifica que tu nombre, email, etc. aparezcan correctamente

## 📝 Valores por Defecto

Si no configuras alguna variable, el proyecto usará valores por defecto definidos en `src/config.ts`:

```typescript
export const config = {
  name: import.meta.env.PUBLIC_NAME || 'Duberney Obando Cano',
  email: import.meta.env.PUBLIC_EMAIL || 'duberney22915@gmail.com',
  // ... etc
};
```

Esto significa que el sitio **siempre funcionará**, incluso sin configurar variables de entorno.

## 🐛 Troubleshooting

### Las variables no se actualizan

1. **Reinicia el servidor de desarrollo**:
   ```bash
   # Ctrl+C para detener
   npm run dev
   ```

2. **Limpia el cache y reconstruye**:
   ```bash
   rm -rf dist .astro
   npm run build
   ```

### Las variables aparecen como "undefined"

1. Verifica que el nombre de la variable empiece con `PUBLIC_`
2. Verifica que no haya espacios alrededor del `=`:
   - ✅ `PUBLIC_NAME=Juan`
   - ❌ `PUBLIC_NAME = Juan`

### Error en Dokploy

1. Verifica que todas las variables estén configuradas
2. Revisa los logs de build en Dokploy
3. Asegúrate de que el Dockerfile tenga los `ARG` correspondientes

## 📚 Archivos Relacionados

- **`.env.example`**: Plantilla con todas las variables
- **`.env`**: Tu configuración local (no se hace commit)
- **`src/config.ts`**: Definición y valores por defecto
- **`Dockerfile`**: Configuración de build arguments

## 🎯 Checklist de Variables

Antes de desplegar, verifica que hayas configurado:

- [ ] `PUBLIC_NAME`
- [ ] `PUBLIC_EMAIL`
- [ ] `PUBLIC_PHONE`
- [ ] `PUBLIC_LOCATION`
- [ ] `PUBLIC_GITHUB_URL`
- [ ] `PUBLIC_LINKEDIN_URL`
- [ ] `PUBLIC_YOUTUBE_URL`
- [ ] `PUBLIC_TWITTER_URL`
- [ ] `PUBLIC_INSTAGRAM_URL`
- [ ] `PUBLIC_TITLE_1`
- [ ] `PUBLIC_TITLE_2`
- [ ] `PUBLIC_TITLE_3`
- [ ] `PUBLIC_CERT_CERTJOIN_URL`
- [ ] `PUBLIC_CERT_HACKING_URL`
- [ ] `PUBLIC_CERT_SENATEC_URL`

---

**Última actualización**: 2025-11-15
