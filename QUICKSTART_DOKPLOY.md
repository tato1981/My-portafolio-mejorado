# ⚡ Guía Rápida: Desplegar en Dokploy

## 🔴 SOLUCIÓN AL ERROR "No start command could be found"

El problema es que estabas usando el tipo de build incorrecto.

## ✅ Configuración Correcta (PASO A PASO)

### 1. En Dokploy, elimina la aplicación actual si ya existe

### 2. Crea una Nueva Aplicación

- Haz clic en **"+ New Application"**
- Nombre: `my-portafolio` (o el que prefieras)
- Conecta tu repositorio de GitHub/GitLab

### 3. Configuración CRÍTICA

En la configuración de la aplicación, establece lo siguiente:

```
Build Type: Static    👈 ⭐ ESTO ES LO MÁS IMPORTANTE
```

**NO USES**:
- ❌ Dockerfile
- ❌ Docker Compose
- ❌ Nixpacks
- ❌ Auto-detect

**USA SOLO**:
- ✅ **Static**

### 4. Configuración de Comandos

```
Install Command:  npm install
Build Command:    npm run build
Publish Directory: dist
```

### 5. Puerto

```
Port: 80
```

### 6. Despliega

Haz clic en **"Deploy"** y espera 2-5 minutos.

## 📋 Checklist Antes de Desplegar

- [ ] Build Type = "Static"
- [ ] Install Command = "npm install"
- [ ] Build Command = "npm run build"
- [ ] Publish Directory = "dist"
- [ ] Puerto = 80

## ✅ Si Todo Va Bien

Verás en los logs:

```
✓ Cloning repository...
✓ Installing dependencies...
✓ Building application...
✓ Deployment successful!
```

Luego podrás visitar tu portafolio en la URL proporcionada por Dokploy.

## 🔍 Qué Hace Dokploy con "Static"

1. Clona tu repositorio
2. Ejecuta `npm install`
3. Ejecuta `npm run build` (genera carpeta `dist/`)
4. Copia el contenido de `dist/` a un servidor NGINX
5. Inicia NGINX automáticamente en puerto 80
6. ¡Listo! Tu sitio está en vivo

## 📸 Captura de Pantalla de Configuración

```
┌─────────────────────────────────────┐
│ Application Settings                │
├─────────────────────────────────────┤
│ Build Type:        [Static ▼]       │ ← SELECCIONA ESTO
│ Install Command:   npm install      │
│ Build Command:     npm run build    │
│ Publish Directory: dist             │
│ Port:              80               │
└─────────────────────────────────────┘
```

## ❓ Preguntas Frecuentes

**P: ¿Necesito el Dockerfile?**
R: NO. Cuando usas build type "Static", Dokploy maneja todo automáticamente.

**P: ¿Por qué "Static" y no "Dockerfile"?**
R: Porque tu sitio de Astro genera archivos estáticos (HTML/CSS/JS). Dokploy tiene un modo específico para esto que es más simple y funciona mejor.

**P: ¿Qué hace el comando "npm run build"?**
R: Compila tu proyecto Astro y genera la carpeta `dist/` con todos los archivos estáticos listos para producción.

**P: ¿Puedo usar mi propio dominio?**
R: Sí, después del despliegue ve a la sección "Domains" en Dokploy y agrega tu dominio. Dokploy configurará SSL automáticamente.

## 📚 Documentación Completa

Para más detalles, revisa `DEPLOY.md` en este repositorio.

---

**Última actualización**: 2025-11-13
