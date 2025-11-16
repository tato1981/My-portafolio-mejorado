# 🚀 Despliegue en Firebase Hosting

Guía completa para desplegar tu portafolio en Firebase Hosting.

## ⚠️ SOLUCIÓN AL ERROR: "Failed to get Firebase project"

Si ves este error:
```
Error: Failed to get Firebase project my-portafolio-proyecto. Please make sure the project exists...
```

**Sigue estos pasos:**

### **Método 1: Usar Firebase Console (Más Fácil)**

1. **Ve a [Firebase Console](https://console.firebase.google.com/)**
2. **Click en "Agregar proyecto" / "Add project"**
3. **Nombre del proyecto**: `mi-portafolio` (o el que prefieras)
4. **Click en "Continuar"** y sigue los pasos
5. **Una vez creado, copia el ID del proyecto**:
   - Click en el ícono de engranaje ⚙️
   - "Configuración del proyecto" / "Project settings"
   - Copia el **"ID del proyecto"** (ejemplo: `mi-portafolio-abc123`)

6. **Actualiza el archivo `.firebaserc`** con tu ID real:
   ```json
   {
     "projects": {
       "default": "mi-portafolio-abc123"
     }
   }
   ```

7. **Intenta desplegar de nuevo**:
   ```bash
   firebase deploy --only hosting
   ```

### **Método 2: Usar un proyecto existente**

Si ya tienes proyectos en Firebase:

1. **Lista tus proyectos**:
   ```bash
   firebase projects:list
   ```

2. **Copia el ID del proyecto** que quieres usar

3. **Actualiza `.firebaserc`** con ese ID

4. **Despliega**:
   ```bash
   firebase deploy --only hosting
   ```

### **Método 3: Usar Firebase Init**

```bash
# 1. Elimina .firebaserc
Remove-Item .firebaserc

# 2. Inicializa Firebase
firebase init hosting

# 3. Selecciona:
#    - Use an existing project (o crea uno nuevo)
#    - Public directory: dist
#    - Configure as SPA: Yes
#    - Overwrite index.html: No

# 4. Despliega
firebase deploy --only hosting
```

---

## 📋 Requisitos Previos

- Node.js instalado (v18 o superior)
- Cuenta de Google
- Proyecto construido (`npm run build`)

---

## 🔧 Paso 1: Instalar Firebase CLI

```bash
npm install -g firebase-tools
```

Verifica la instalación:
```bash
firebase --version
```

---

## 🔐 Paso 2: Autenticarse en Firebase

```bash
firebase login
```

Se abrirá tu navegador para iniciar sesión con tu cuenta de Google.

---

## 📦 Paso 3: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Click en "Agregar proyecto" / "Add project"
3. Nombre del proyecto: `my-portafolio` (o el que prefieras)
4. Acepta los términos
5. (Opcional) Desactiva Google Analytics si no lo necesitas
6. Click en "Crear proyecto"
7. Espera a que se cree (30-60 segundos)

---

## ⚙️ Paso 4: Configurar el Proyecto

### Actualizar `.firebaserc`

Abre el archivo `.firebaserc` y reemplaza `"my-portafolio-proyecto"` con el **ID real** de tu proyecto de Firebase.

Para encontrar tu ID de proyecto:
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Click en el ícono de engranaje ⚙️ → "Configuración del proyecto"
4. Copia el "ID del proyecto"

Ejemplo:
```json
{
  "projects": {
    "default": "my-portafolio-abc123"
  }
}
```

---

## 🏗️ Paso 5: Construir el Proyecto

```bash
npm run build
```

Esto genera la carpeta `dist/` con los archivos estáticos.

---

## 🚀 Paso 6: Desplegar

```bash
firebase deploy --only hosting
```

### Primera vez

Si es la primera vez que despliegas, Firebase te preguntará:

1. **"What do you want to use as your public directory?"**
   - Respuesta: `dist`

2. **"Configure as a single-page app?"**
   - Respuesta: `Yes`

3. **"Set up automatic builds and deploys with GitHub?"**
   - Respuesta: `No` (o `Yes` si quieres CI/CD)

### Resultado

Verás algo como:
```
✔ Deploy complete!

Project Console: https://console.firebase.google.com/project/my-portafolio/overview
Hosting URL: https://my-portafolio.web.app
```

---

## 🌐 Paso 7: Verificar el Despliegue

Abre la URL que te proporciona Firebase:
- `https://tu-proyecto.web.app`
- `https://tu-proyecto.firebaseapp.com`

---

## 🔄 Actualizar el Sitio

Cada vez que hagas cambios:

```bash
# 1. Construir
npm run build

# 2. Desplegar
firebase deploy --only hosting
```

O en un solo comando:
```bash
npm run build && firebase deploy --only hosting
```

---

## 📝 Script de Despliegue Rápido

Agrega este script a tu `package.json`:

```json
{
  "scripts": {
    "deploy": "npm run build && firebase deploy --only hosting"
  }
}
```

Luego solo ejecuta:
```bash
npm run deploy
```

---

## 🌍 Dominio Personalizado (Opcional)

1. Ve a Firebase Console → Tu proyecto → Hosting
2. Click en "Agregar dominio personalizado"
3. Ingresa tu dominio (ejemplo: `miportafolio.com`)
4. Sigue las instrucciones para configurar DNS
5. Firebase configurará SSL automáticamente

---

## ⚡ Características de Firebase Hosting

✅ **SSL/HTTPS gratuito y automático**
✅ **CDN global** - Contenido servido desde el servidor más cercano
✅ **Despliegues instantáneos** - Cambios en segundos
✅ **Rollback fácil** - Vuelve a versiones anteriores
✅ **Gratis** - 10GB almacenamiento, 360MB/día transferencia
✅ **Cache optimizado** - Configurado automáticamente

---

## 🔍 Comandos Útiles

```bash
# Ver proyectos disponibles
firebase projects:list

# Cambiar de proyecto
firebase use <project-id>

# Ver versiones desplegadas
firebase hosting:releases:list

# Preview local del sitio
firebase serve --only hosting

# Ver logs
firebase hosting:logs
```

---

## 🐛 Solución de Problemas

### Error: "No authorization"
```bash
firebase logout
firebase login
```

### Error: "Permission denied"
Verifica que tu cuenta de Google tenga permisos en el proyecto.

### La página muestra contenido antiguo
- Limpia cache del navegador (Ctrl+Shift+R)
- Prueba en modo incógnito
- Espera 5-10 minutos para que el CDN actualice

### Error 404 en rutas
El archivo `firebase.json` ya está configurado correctamente con rewrites.

### Formulario no funciona
El formulario usa Formspree, funcionará en cualquier hosting. Asegúrate de haber configurado el Form ID.

---

## 📊 Monitoreo

### Ver estadísticas
1. Ve a Firebase Console
2. Selecciona tu proyecto
3. Hosting → Pestaña "Usage"

Verás:
- Solicitudes totales
- Transferencia de datos
- Versiones desplegadas

### Rollback a versión anterior
1. Firebase Console → Hosting → Pestaña "Releases"
2. Busca la versión anterior
3. Click en "..." → "Rollback"

---

## 📁 Estructura de Archivos Firebase

```
/
├── firebase.json       # Configuración de Firebase Hosting
├── .firebaserc        # ID del proyecto
└── dist/              # Archivos construidos (generados por npm run build)
```

---

## ✅ Checklist de Despliegue

- [ ] Firebase CLI instalado globalmente
- [ ] Autenticado con `firebase login`
- [ ] Proyecto creado en Firebase Console
- [ ] `.firebaserc` actualizado con el ID del proyecto
- [ ] `npm run build` ejecutado sin errores
- [ ] `firebase deploy --only hosting` ejecutado exitosamente
- [ ] Sitio accesible en la URL de Firebase
- [ ] Formulario de contacto configurado con Formspree

---

## 🎯 URLs Importantes

- **Firebase Console**: https://console.firebase.google.com/
- **Documentación**: https://firebase.google.com/docs/hosting
- **Precios**: https://firebase.google.com/pricing (Gratis hasta 10GB)

---

**Última actualización**: 2025-11-15
**Build Status**: ✅ 0 errores, 0 warnings, 0 hints
