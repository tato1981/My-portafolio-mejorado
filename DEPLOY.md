# Guía de Despliegue en Dokploy

Este documento describe cómo desplegar el portafolio en Dokploy.

## Requisitos Previos

1. Cuenta en Dokploy
2. Repositorio Git (GitHub, GitLab, etc.)
3. Proyecto configurado con los archivos necesarios

## Archivos de Configuración

Este proyecto incluye los siguientes archivos para el despliegue:

- `Dockerfile`: Define la imagen Docker multi-stage (Node.js + Nginx)
- `docker-compose.yml`: Configuración de Docker Compose para Dokploy
- `dokploy.json`: Configuración mínima de Dokploy
- `nginx.conf`: Configuración del servidor web Nginx
- `.dockerignore`: Archivos excluidos del build de Docker

## ⚡ IMPORTANTE: Tipo de Build Correcto

Para sitios estáticos de Astro, Dokploy tiene un build type específico llamado **"Static"** que:
- ✅ Ejecuta automáticamente `npm install` y `npm run build`
- ✅ Toma la carpeta `dist` (salida de Astro)
- ✅ La sirve con NGINX optimizado automáticamente
- ✅ No requiere Dockerfile personalizado

## Opciones de Despliegue

### Opción 1: Build Type "Static" (Más Simple - Recomendado para principiantes)

**✅ USAR**:
- **"Static"** (Build Type específico para sitios estáticos)

**Ventajas**:
- Configuración más simple
- Dokploy maneja Nginx automáticamente
- No necesitas entender Docker

### Opción 2: Build Type "Dockerfile" (Más Control - Recomendado para configuración avanzada)

**✅ USAR**:
- **"Dockerfile"** con el Dockerfile incluido en este proyecto

**Ventajas**:
- Control total sobre la configuración de Nginx
- Healthchecks personalizados
- Optimizaciones específicas
- Configuración de seguridad avanzada

**Última actualización (2025-11-13)**:
- ✅ Favicon corregido (ya no da error 502)
- ✅ Dockerfile mejorado con healthcheck
- ✅ Nginx optimizado con headers de seguridad
- ✅ Manejo robusto de archivos estáticos

## Pasos para Desplegar

### 1. Preparar el Repositorio

Asegúrate de que todos los cambios estén commiteados y pusheados a tu repositorio:

```bash
git add .
git commit -m "Configuración lista para Dokploy con Docker Compose"
git push origin main
```

### 2. Crear Aplicación en Dokploy

1. Inicia sesión en tu panel de Dokploy
2. Haz clic en **"Create New Application"** o **"+ New Project"**
3. Ingresa el nombre de tu aplicación (ej: "my-portafolio")
4. Conecta tu repositorio Git:
   - Selecciona tu provider (GitHub, GitLab, Bitbucket, etc.)
   - Autoriza el acceso si es necesario
   - Selecciona el repositorio del portafolio
   - Selecciona la rama `main` (o la rama que uses)

### 3. Configurar el Build Type

**🔴 PASO CRÍTICO - Este es el que soluciona el error:**

1. En la configuración de la aplicación, busca **"Build Type"**
2. **Selecciona "Static"** (NO Dockerfile, NO Docker Compose, NO Nixpacks)
3. Configura los siguientes campos:

   **Install Command**:
   ```
   npm install
   ```

   **Build Command**:
   ```
   npm run build
   ```

   **Publish Directory**:
   ```
   dist
   ```

4. **Puerto**: Asegúrate de que el puerto sea `80` (Dokploy usa NGINX automáticamente)

### 4. Configurar Dominio (Opcional)

Si quieres asignar un dominio:

1. Ve a la sección **"Domains"**
2. Haz clic en **"Add Domain"**
3. Ingresa tu dominio o usa el subdominio gratuito de Dokploy
4. **Puerto**: Usa `80` (puerto interno de NGINX)
5. Dokploy configurará automáticamente SSL con Let's Encrypt

### 5. Variables de Entorno (Opcional)

Para este proyecto no se necesitan variables de entorno adicionales, pero si quieres agregar alguna:

1. Ve a **"Environment Variables"**
2. Agrega las variables que necesites
3. Ejemplo:
   ```
   NODE_ENV=production
   ```

### 6. Iniciar Despliegue

1. **Revisa toda la configuración**:
   - Build Type: **Static** ✅
   - Install Command: `npm install` ✅
   - Build Command: `npm run build` ✅
   - Publish Directory: `dist` ✅
   - Puerto: `80` ✅

2. Haz clic en **"Deploy"** o **"Build & Deploy"**

3. Observa los logs de build en tiempo real

4. Espera a que se complete el build (2-5 minutos típicamente)

### 7. Verificar el Build

Durante el build, deberías ver en los logs algo como:

```
Cloning repository...
Installing dependencies (npm install)...
Building application (npm run build)...
✓ Built in X.XXs
Copying dist folder to NGINX...
Starting NGINX server on port 80...
✅ Deployment successful!
```

Si ves errores, revisa la sección de Troubleshooting más abajo.

## Verificar el Despliegue

### Verificar Estado en Dokploy

1. En el panel de Dokploy, verifica que el status sea **"Running"** (verde)
2. Verifica que no haya errores en los logs

### Visitar tu Portafolio

1. Si configuraste un dominio: `https://tu-dominio.com`
2. O usa la URL proporcionada por Dokploy
3. Deberías ver tu portafolio funcionando correctamente

### Health Check (Opcional)

Si configuraste el nginx.conf, puedes visitar `https://tu-dominio/health` para verificar que NGINX esté funcionando.

## Arquitectura del Despliegue con Build Type "Static"

### Cómo Funciona

Cuando usas el build type **"Static"** en Dokploy:

1. **Clonado**: Dokploy clona tu repositorio desde GitHub/GitLab
2. **Instalación**: Ejecuta `npm install` en el servidor
3. **Build**: Ejecuta `npm run build` (genera la carpeta `dist/`)
4. **Despliegue**: Copia automáticamente el contenido de `dist/` a `/usr/share/nginx/html`
5. **Servidor**: Inicia NGINX optimizado automáticamente en puerto 80
6. **SSL**: Configura SSL automáticamente si tienes un dominio

### Ventajas de usar "Static" Build Type

- ✅ **Sin Dockerfile necesario**: Dokploy maneja todo automáticamente
- ✅ **NGINX optimizado**: Usa la configuración de NGINX más eficiente
- ✅ **Build automático**: Solo defines los comandos, Dokploy los ejecuta
- ✅ **SSL automático**: Let's Encrypt se configura automáticamente
- ✅ **Actualizaciones fáciles**: Solo haz push y Dokploy rebuilds automáticamente

## Optimizaciones Incluidas

El build type "Static" de Dokploy incluye automáticamente:

- ✅ **Compresión Gzip**: Reduce el tamaño de transferencia
- ✅ **Cache de assets**: Mejora velocidad de carga
- ✅ **Security headers**: Protección básica
- ✅ **SPA routing**: Fallback a index.html para rutas
- ✅ **SSL/HTTPS**: Certificados Let's Encrypt automáticos
- ✅ **HTTP/2**: Protocolo moderno habilitado

## Troubleshooting

### ⚠️ Error: "No start command could be found"

**Causa**: Estás usando el tipo de build incorrecto. Este proyecto es un sitio estático de Astro.

**Solución DEFINITIVA**:

1. **Elimina la aplicación actual** en Dokploy
2. **Crea una nueva aplicación**
3. **Conecta tu repositorio**
4. **EN LA CONFIGURACIÓN**:
   - Build Type: Selecciona **"Static"** ⭐ (NO Dockerfile, NO Docker Compose)
   - Install Command: `npm install`
   - Build Command: `npm run build`
   - Publish Directory: `dist`
   - Puerto: `80`
5. **Haz clic en Deploy**

**Por qué funciona**: El build type "Static" está diseñado específicamente para sitios estáticos como Astro, Next.js exportado, etc. Dokploy maneja automáticamente NGINX y toda la configuración.

### ⚠️ Error: "No such container: myportafolio-frontend-xxxx"

**Causa**: El build type incorrecto previene que se cree el contenedor.

**Solución**:

Sigue los pasos del error anterior. Usa **Build Type: "Static"** y el contenedor se creará automáticamente.

### Error 502 Bad Gateway

Si encuentras un error 502:

1. Verifica que el contenedor esté corriendo en Dokploy (status: Running)
2. Revisa los logs del contenedor en Dokploy
3. Verifica el health check visitando: `https://tu-dominio/health`
4. Asegúrate de que el puerto 80 esté correctamente mapeado

### Build Fallido

Si el build falla:

1. **Revisa los logs de build completos** en Dokploy
2. Busca errores específicos:
   - Errores de npm install → verifica `package.json`
   - Errores de npm run build → prueba localmente: `npm run build`
   - Errores de Docker → verifica sintaxis del `Dockerfile`
3. Verifica que todas las dependencias estén en `package.json`
4. Asegúrate de que el build funcione localmente

### Contenedor no Inicia

Si el contenedor no inicia:

1. Revisa los logs del contenedor en Dokploy
2. Verifica que Nginx esté configurado correctamente en `nginx.conf`
3. Verifica que los archivos compilados existan (revisa el log del build stage)
4. Intenta ejecutar el health check: `wget http://localhost/health`

## Actualizar el Despliegue

Para actualizar tu portafolio:

1. Haz los cambios en tu código
2. Commitea y pushea a tu repositorio
3. En Dokploy, haz clic en "Redeploy"
4. El nuevo build se desplegará automáticamente

## Comandos Útiles

### Verificar Build Localmente

```bash
# Build del proyecto
npm run build

# Preview local
npm run preview
```

### Build de Docker Localmente

```bash
# Build de la imagen
docker build -t portafolio .

# Ejecutar localmente
docker run -p 8080:80 portafolio

# Visitar en el navegador
http://localhost:8080
```

### Verificar Logs

```bash
# Logs del contenedor
docker logs <container-id>

# Logs en tiempo real
docker logs -f <container-id>
```

## Optimizaciones Aplicadas

1. **Multi-stage build**: Reduce el tamaño de la imagen final
2. **npm ci**: Builds reproducibles y más rápidos
3. **Gzip compression**: Reduce el tamaño de transferencia
4. **Cache headers**: Mejora la velocidad de carga
5. **Health checks**: Monitoreo automático del servicio
6. **Security headers**: Protección básica contra ataques comunes

## Seguridad

- Nginx corre como usuario no-root
- Headers de seguridad configurados
- Archivos ocultos bloqueados
- Permisos de archivos correctamente configurados

## Soporte

Si tienes problemas con el despliegue:

1. Revisa los logs en Dokploy
2. Verifica la configuración en `dokploy.json`
3. Prueba el build localmente con Docker
4. Contacta al soporte de Dokploy si es necesario

---

**Última actualización**: 2025-11-13
**Versión del proyecto**: 0.0.1
**Framework**: Astro 5.13.11
