# 🚀 Guía de Despliegue en Firebase Hosting

Esta guía te ayudará a desplegar tu portafolio de Astro en Firebase Hosting paso a paso.

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Configuración Inicial](#configuración-inicial)
3. [Despliegue](#despliegue)
4. [Actualizaciones](#actualizaciones)
5. [Configuración Avanzada](#configuración-avanzada)
6. [Solución de Problemas](#solución-de-problemas)

---

## ✅ Requisitos Previos

Antes de comenzar, asegúrate de tener:

1. **Node.js y npm instalados**
   - Verifica: `node --version` (debe ser v18 o superior)
   - Verifica: `npm --version`

2. **Cuenta de Google**
   - Necesaria para acceder a Firebase Console

3. **Firebase CLI instalado globalmente**
   ```bash
   npm install -g firebase-tools
   ```
   - Verifica: `firebase --version`

---

## 🔧 Configuración Inicial

### Paso 1: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en **"Agregar proyecto"** o **"Create a project"**
3. Ingresa el nombre de tu proyecto (ejemplo: `my-portafolio`)
4. (Opcional) Desactiva Google Analytics si no lo necesitas
5. Haz clic en **"Crear proyecto"**
6. Espera a que se cree el proyecto (30-60 segundos)
7. Haz clic en **"Continuar"**

### Paso 2: Activar Firebase Hosting

1. En el panel de Firebase, ve a la sección **"Build"** en el menú lateral
2. Haz clic en **"Hosting"**
3. Haz clic en **"Comenzar"** o **"Get started"**
4. Sigue los pasos (Firebase CLI ya está instalado)
5. Haz clic en **"Siguiente"** hasta completar

### Paso 3: Autenticar Firebase CLI

Abre tu terminal y ejecuta:

```bash
firebase login
```

- Se abrirá tu navegador
- Inicia sesión con tu cuenta de Google
- Autoriza el acceso a Firebase CLI
- Verás un mensaje de éxito en la terminal

### Paso 4: Configurar el Proyecto

Los archivos de configuración ya están creados en este proyecto:
- ✅ `firebase.json` - Configuración de hosting
- ✅ `.firebaserc` - Configuración del proyecto

**IMPORTANTE**: Debes actualizar `.firebaserc` con tu ID de proyecto:

1. Abre `.firebaserc`
2. Reemplaza `"my-portafolio-proyecto"` con el ID de tu proyecto de Firebase
3. Para encontrar tu ID de proyecto:
   - Ve a [Firebase Console](https://console.firebase.google.com/)
   - Haz clic en **"Configuración del proyecto"** (ícono de engranaje)
   - Copia el **"ID del proyecto"**

Ejemplo de `.firebaserc`:
```json
{
  "projects": {
    "default": "mi-portafolio-12345"
  }
}
```

---

## 🚀 Despliegue

### Primer Despliegue

1. **Construir el proyecto**:
   ```bash
   npm run build
   ```
   - Esto genera la carpeta `dist/` con los archivos estáticos
   - Verifica que se completó sin errores

2. **Verificar la configuración de Firebase**:
   ```bash
   firebase projects:list
   ```
   - Deberías ver tu proyecto listado
   - Si no aparece, verifica el `.firebaserc`

3. **Desplegar a Firebase Hosting**:
   ```bash
   firebase deploy --only hosting
   ```

   Durante el despliegue verás:
   ```
   === Deploying to 'mi-portafolio'...

   i  deploying hosting
   i  hosting[mi-portafolio]: beginning deploy...
   i  hosting[mi-portafolio]: found X files in dist
   ✔  hosting[mi-portafolio]: file upload complete
   i  hosting[mi-portafolio]: finalizing version...
   ✔  hosting[mi-portafolio]: version finalized
   i  hosting[mi-portafolio]: releasing new version...
   ✔  hosting[mi-portafolio]: release complete

   ✔  Deploy complete!

   Project Console: https://console.firebase.google.com/project/mi-portafolio/overview
   Hosting URL: https://mi-portafolio.web.app
   ```

4. **Visitar tu sitio**:
   - Firebase te proporcionará 2 URLs:
     - `https://tu-proyecto.web.app`
     - `https://tu-proyecto.firebaseapp.com`
   - Ambas funcionan igual, usa la que prefieras

---

## 🔄 Actualizaciones

Cada vez que hagas cambios a tu portafolio:

1. **Hacer cambios en tu código**
2. **Construir nuevamente**:
   ```bash
   npm run build
   ```
3. **Desplegar**:
   ```bash
   firebase deploy --only hosting
   ```

### Script Rápido (Opcional)

Puedes agregar este script a tu `package.json`:

```json
{
  "scripts": {
    "deploy": "npm run build && firebase deploy --only hosting",
    "deploy:preview": "npm run build && firebase hosting:channel:deploy preview"
  }
}
```

Luego simplemente ejecuta:
```bash
npm run deploy
```

---

## ⚙️ Configuración Avanzada

### Dominio Personalizado

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **"Hosting"**
4. Haz clic en **"Agregar dominio personalizado"**
5. Ingresa tu dominio (ejemplo: `miportafolio.com`)
6. Sigue las instrucciones para configurar DNS
7. Firebase configurará SSL automáticamente (puede tomar 24 horas)

### Preview Channels (Canales de Vista Previa)

Útil para probar cambios antes de desplegarlos a producción:

```bash
# Crear un canal de vista previa
firebase hosting:channel:deploy preview

# Ver el URL temporal
# Firebase te dará un URL como: https://tu-proyecto--preview-xxxxx.web.app
```

### Múltiples Entornos

Puedes configurar múltiples entornos (staging, producción):

1. Crea proyectos separados en Firebase Console
2. Actualiza `.firebaserc`:
   ```json
   {
     "projects": {
       "default": "mi-portafolio-prod",
       "staging": "mi-portafolio-staging"
     }
   }
   ```
3. Despliega a staging:
   ```bash
   firebase use staging
   firebase deploy --only hosting
   ```
4. Despliega a producción:
   ```bash
   firebase use default
   firebase deploy --only hosting
   ```

---

## 🐛 Solución de Problemas

### Error: "No authorization"

**Problema**: No has iniciado sesión en Firebase CLI.

**Solución**:
```bash
firebase logout
firebase login
```

### Error: "Permission denied"

**Problema**: No tienes permisos en el proyecto de Firebase.

**Solución**:
1. Verifica que el ID del proyecto en `.firebaserc` sea correcto
2. Asegúrate de que tu cuenta de Google tenga permisos en el proyecto
3. Ve a Firebase Console → Configuración → Usuarios y permisos

### Error: "Cannot find module 'dist'"

**Problema**: No has construido el proyecto.

**Solución**:
```bash
npm run build
```

### La página muestra contenido antiguo

**Problema**: Cache del navegador.

**Solución**:
1. Limpia la cache del navegador (Ctrl+Shift+R o Cmd+Shift+R)
2. Prueba en modo incógnito
3. Espera 5-10 minutos para que el CDN de Firebase actualice

### Error 404 en rutas

**Problema**: Configuración de rewrites incorrecta.

**Solución**:
- Verifica que `firebase.json` tenga la configuración de rewrites correcta
- Ya está configurado en este proyecto ✅

### Assets no cargan (imágenes, CSS, JS)

**Problema**: Rutas incorrectas o archivos no construidos.

**Solución**:
1. Verifica que `npm run build` completó exitosamente
2. Revisa que los archivos estén en `dist/`
3. Verifica las rutas en tu código (deben ser relativas o absolutas desde `/`)

### Despliegue muy lento

**Problema**: Muchos archivos o archivos muy grandes.

**Solución**:
1. Optimiza imágenes antes de desplegar
2. Verifica que `node_modules/` no esté en `dist/` (debe estar en `.gitignore`)
3. Usa compresión de imágenes (WebP, optimización)

---

## 📊 Ventajas de Firebase Hosting

✅ **Gratis** (plan Spark): 10GB de hosting, 360MB/día de transferencia
✅ **SSL automático**: HTTPS habilitado desde el primer momento
✅ **CDN Global**: Contenido servido desde el servidor más cercano al usuario
✅ **Despliegue rápido**: Cambios en segundos
✅ **Rollback fácil**: Vuelve a versiones anteriores con un clic
✅ **Preview channels**: Prueba cambios antes de desplegar a producción
✅ **Dominio personalizado gratuito**: Conecta tu propio dominio
✅ **Analytics integrado**: Estadísticas de tráfico (opcional)

---

## 📈 Monitoreo y Análisis

### Ver Historial de Despliegues

```bash
firebase hosting:releases:list
```

### Ver Uso de Hosting

1. Ve a Firebase Console
2. Selecciona tu proyecto
3. Ve a **"Hosting"**
4. Verás gráficas de:
   - Solicitudes
   - Transferencia de datos
   - Versiones desplegadas

### Rollback a Versión Anterior

1. Ve a Firebase Console → Hosting
2. Haz clic en la pestaña **"Versiones"**
3. Encuentra la versión anterior
4. Haz clic en los tres puntos → **"Rollback"**

---

## 🔒 Configuración de Seguridad Incluida

El archivo `firebase.json` ya incluye:

✅ **Headers de Seguridad**:
- `X-Content-Type-Options: nosniff` - Previene ataques MIME
- `X-Frame-Options: SAMEORIGIN` - Previene clickjacking
- `X-XSS-Protection: 1; mode=block` - Protección XSS

✅ **Cache Optimizado**:
- Assets estáticos: Cache de 1 año
- HTML: Sin cache (siempre actualizado)

✅ **Clean URLs**: URLs sin `.html`

---

## 🎯 Comandos Útiles de Firebase CLI

```bash
# Ver proyectos disponibles
firebase projects:list

# Cambiar de proyecto
firebase use <project-id>

# Ver configuración actual
firebase projects:describe

# Inicializar otras funcionalidades de Firebase
firebase init

# Ver logs de hosting
firebase hosting:logs

# Eliminar un sitio (¡cuidado!)
firebase hosting:sites:delete <site-name>

# Ver versiones desplegadas
firebase hosting:releases:list

# Preview local (sirve los archivos de dist/)
firebase serve --only hosting
```

---

## 📞 Recursos Adicionales

- **Documentación Oficial**: https://firebase.google.com/docs/hosting
- **Firebase Console**: https://console.firebase.google.com/
- **Precios de Firebase**: https://firebase.google.com/pricing
- **Comunidad Firebase**: https://firebase.google.com/community
- **Stack Overflow**: [firebase-hosting](https://stackoverflow.com/questions/tagged/firebase-hosting)

---

## ✅ Checklist de Despliegue

- [ ] Node.js y npm instalados
- [ ] Firebase CLI instalado (`npm install -g firebase-tools`)
- [ ] Cuenta de Google creada
- [ ] Proyecto creado en Firebase Console
- [ ] Firebase Hosting activado
- [ ] Autenticado con `firebase login`
- [ ] `.firebaserc` actualizado con tu ID de proyecto
- [ ] `npm run build` ejecutado sin errores
- [ ] `firebase deploy --only hosting` ejecutado exitosamente
- [ ] Sitio accesible en la URL de Firebase
- [ ] Favicon cargando correctamente
- [ ] Todas las secciones funcionando

---

## 🎉 ¡Listo!

Tu portafolio debería estar ahora desplegado en Firebase Hosting y accesible públicamente.

**URLs de ejemplo**:
- Hosting URL: `https://mi-portafolio.web.app`
- Firebase Console: `https://console.firebase.google.com/project/mi-portafolio`

**¿Necesitas ayuda?**
- Revisa la sección de [Solución de Problemas](#solución-de-problemas)
- Consulta los [Recursos Adicionales](#recursos-adicionales)
- Revisa los logs con `firebase hosting:logs`

---

**Última actualización**: 2025-11-13
**Framework**: Astro 5.13.11
**Firebase CLI requerido**: v13.0.0 o superior
