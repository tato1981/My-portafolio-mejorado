# Configuraciones Alternativas para Dokploy

Este archivo contiene diferentes configuraciones de `dokploy.json` dependiendo del método de despliegue que prefieras usar en Dokploy.

## Opción 1: Usar Dockerfile (Recomendado - Mayor Control)

Usa esta configuración si quieres control total sobre el entorno de build y producción:

```json
{
  "name": "my-portafolio",
  "buildType": "dockerfile",
  "dockerfile": "Dockerfile",
  "dockerContext": ".",
  "port": 80
}
```

**Ventajas:**
- ✅ Control total del entorno
- ✅ Build reproducible
- ✅ Optimizado con multi-stage
- ✅ Funciona en cualquier plataforma Docker

**Pasos en Dokploy:**
1. En la configuración de la app, selecciona **Build Type: "Dockerfile"**
2. No necesitas configurar comandos de build, el Dockerfile lo maneja todo
3. El puerto debe ser **80**

---

## Opción 2: Build Type Static (Más Simple)

Si prefieres que Dokploy maneje todo automáticamente sin Dockerfile:

```json
{
  "name": "my-portafolio",
  "buildType": "static",
  "publishDirectory": "dist",
  "buildCommand": "npm run build",
  "installCommand": "npm install"
}
```

**Ventajas:**
- ✅ Configuración más simple
- ✅ No requiere conocimiento de Docker
- ✅ Dokploy maneja Nginx automáticamente

**Pasos en Dokploy:**
1. En la configuración de la app, selecciona **Build Type: "Static"**
2. Install Command: `npm install`
3. Build Command: `npm run build`
4. Publish Directory: `dist`
5. Puerto: **80**

---

## Opción 3: Docker Compose (Para Múltiples Servicios)

Si necesitas múltiples servicios (base de datos, cache, etc.):

```json
{
  "name": "my-portafolio",
  "buildType": "docker-compose",
  "composeFile": "docker-compose.yml"
}
```

**Nota:** El proyecto actual solo necesita un servicio web, así que esta opción es innecesaria.

---

## Configuración Actual Aplicada

El archivo `dokploy.json` actual está configurado para usar **Dockerfile** (Opción 1).

---

## Solución a Errores Comunes en Dokploy

### Error: "failed to solve: process /bin/bash -ol pipefail -c npm run build did not complete successfully"

**Causa:** Dokploy está intentando usar Nixpacks (auto-detect) en lugar del método configurado.

**Solución:**

1. **Verifica en Dokploy UI:**
   - Ve a la configuración de tu aplicación
   - Busca "Build Type" o "Deployment Method"
   - Asegúrate de que esté seleccionado **"Dockerfile"** (no "Auto" ni "Nixpacks")

2. **Si usas Dockerfile:**
   - Verifica que el archivo `Dockerfile` exista en la raíz
   - Verifica que no haya errores de sintaxis en el Dockerfile
   - Push los cambios: `git push origin main`

3. **Si usas Static:**
   - Cambia a Build Type: "Static" en Dokploy UI
   - Configura los comandos manualmente en la interfaz
   - Redeploy

### Error: "No such container: portafolio-frontend-xxxxx"

**Causa:** El build falló antes de crear el contenedor.

**Solución:**
1. Revisa los logs completos del build en Dokploy
2. Busca el error real más arriba en los logs
3. Asegúrate de que `npm run build` funcione localmente: `npm ci && npm run build`

### Error: "UndefinedVar: Usage of undefined variable '$NIXPACKS_PATH'"

**Causa:** Dokploy está usando Nixpacks en lugar de Dockerfile.

**Solución:**
1. **En Dokploy UI:**
   - Settings → Build Configuration
   - Cambia "Build Method" de "Auto" o "Nixpacks" a **"Dockerfile"**
2. **O elimina y recrea la aplicación:**
   - Elimina la aplicación actual en Dokploy
   - Crea una nueva
   - Al crear, selecciona **"Dockerfile"** como Build Type desde el inicio
   - Conecta tu repositorio
   - Deploy

---

## Verificación Local

Antes de hacer push a Dokploy, verifica que todo funcione localmente:

### Verificar Build de Node
```powershell
npm ci
npm run build
```

Debe completar sin errores y generar la carpeta `dist/`.

### Verificar Docker Build (si usas Dockerfile)
```powershell
docker build -t portafolio-test .
docker run -p 8080:80 portafolio-test
```

Visita `http://localhost:8080` y verifica que el sitio funcione.

### Verificar Docker Compose (si usas docker-compose.yml)
```powershell
npm run build  # Primero genera dist/
docker-compose up
```

Visita `http://localhost` y verifica que el sitio funcione.

---

## Recomendación Final

Para este proyecto (portafolio estático de Astro), la **Opción 1 (Dockerfile)** es la más recomendada porque:

1. ✅ Funciona consistentemente en cualquier entorno
2. ✅ El Dockerfile ya está optimizado con multi-stage build
3. ✅ Más rápido y eficiente que Nixpacks
4. ✅ Fácil de depurar

**Pasos finales:**
1. Asegúrate de que `dokploy.json` tenga `"buildType": "dockerfile"`
2. Push a tu repositorio: `git push origin main`
3. En Dokploy UI, verifica que Build Type sea "Dockerfile"
4. Redeploy

---

**Última actualización:** 2025-11-13
