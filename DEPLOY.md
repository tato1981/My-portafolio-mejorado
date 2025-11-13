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

## Solución a Errores Comunes

### Error: "No start command could be found"

Este error ocurre cuando Dokploy no puede determinar cómo iniciar la aplicación. La solución es usar **Docker Compose** en lugar de solo Dockerfile:

1. **Asegúrate de que existe `docker-compose.yml`** en la raíz del proyecto
2. **En Dokploy, selecciona el tipo de despliegue "Docker Compose"** en lugar de "Dockerfile"
3. Dokploy usará automáticamente el archivo `docker-compose.yml`

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
2. Haz clic en **"Create New Application"** o **"New Project"**
3. **IMPORTANTE: Selecciona "Docker Compose" como tipo de despliegue** (NO "Dockerfile")
4. Conecta tu repositorio Git:
   - Selecciona tu provider (GitHub, GitLab, etc.)
   - Autoriza el acceso si es necesario
   - Selecciona el repositorio del portafolio
   - Selecciona la rama `main` (o la rama que uses)

### 3. Configurar la Aplicación

Dokploy detectará automáticamente el archivo `docker-compose.yml` y usará su configuración.

#### Configuración Automática (desde docker-compose.yml)

El archivo `docker-compose.yml` ya incluye:
- Puerto: `80:80` (interno:externo)
- Variables de entorno: `NODE_ENV=production`
- Health check configurado en `/health`
- Restart policy: `unless-stopped`

#### Configuración Adicional en Dokploy (Opcional)

Si quieres cambiar el puerto externo:

1. En Dokploy, ve a la configuración de la aplicación
2. En la sección de **Ports**, puedes cambiar el puerto externo (por ejemplo, de `80` a `3000`)
3. El formato es: `puerto_externo:puerto_interno`

Ejemplo: `3000:80` expondrá la aplicación en el puerto 3000

#### Variables de Entorno (Ya Configuradas)

El proyecto ya tiene configurado:
```
NODE_ENV=production
```

No necesitas agregar variables adicionales, pero puedes hacerlo si lo necesitas desde el panel de Dokploy.

### 4. Iniciar Despliegue

1. **Revisa la configuración** en el panel de Dokploy
2. Haz clic en **"Deploy"** o **"Build & Deploy"**
3. Observa los logs de build en tiempo real
4. Espera a que se complete el build (puede tomar 3-7 minutos en el primer despliegue)
5. Verifica que el contenedor esté corriendo (status: Running)

### 5. Verificar el Build

Durante el build, deberías ver en los logs:

```
Step 1: Building Node.js application...
Step 2: Installing dependencies...
Step 3: Running npm run build...
Step 4: Creating Nginx image...
Step 5: Starting container...
```

Si ves errores, revisa la sección de Troubleshooting más abajo.

## Verificar el Despliegue

### Health Check

Visita `https://tu-dominio/health` para verificar que el servidor esté funcionando.

### Página Principal

Visita `https://tu-dominio` para ver tu portafolio en vivo.

## Arquitectura del Despliegue

### Build Stage (Dockerfile)

1. **Imagen Base**: Node.js 20 Alpine
2. **Instalación**: Dependencias con `npm ci`
3. **Build**: Compilación con `npm run build`
4. **Output**: Archivos estáticos en `/app/dist`

### Production Stage (Dockerfile)

1. **Imagen Base**: Nginx Alpine
2. **Archivos**: Copia de `/app/dist` a `/usr/share/nginx/html`
3. **Configuración**: Nginx optimizado para SPA
4. **Puerto**: 80 (HTTP)

## Características de la Configuración

### Nginx

- Compresión Gzip habilitada
- Cache de assets estáticos (1 año)
- Security headers configurados
- Fallback a `index.html` para rutas SPA
- Logs de acceso y errores

### Docker

- Build multi-stage para imagen optimizada
- Health check integrado
- Permisos correctos configurados
- Logs en stdout/stderr

## Troubleshooting

### ⚠️ Error: "No start command could be found"

**Causa**: Dokploy está intentando detectar automáticamente el tipo de proyecto en lugar de usar Docker Compose.

**Solución**:

1. **Elimina la aplicación actual** en Dokploy (si ya existe)
2. **Crea una nueva aplicación** desde cero
3. **Selecciona "Docker Compose"** como tipo de despliegue (NO "Dockerfile" ni "Auto-detect")
4. Conecta el repositorio nuevamente
5. Despliega

El archivo `docker-compose.yml` en la raíz del proyecto será detectado automáticamente.

### ⚠️ Error: "No such container: myportafolio-frontend-xxxx"

**Causa**: El contenedor no se creó porque el tipo de despliegue era incorrecto o el build falló.

**Solución**:

1. Verifica que estés usando **"Docker Compose"** como tipo de despliegue
2. Revisa los logs de build completos en Dokploy para ver dónde falló
3. Asegúrate de que estos archivos existan en tu repositorio:
   - `Dockerfile` (raíz del proyecto)
   - `docker-compose.yml` (raíz del proyecto)
   - `nginx.conf` (raíz del proyecto)
   - `package.json` (raíz del proyecto)

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
