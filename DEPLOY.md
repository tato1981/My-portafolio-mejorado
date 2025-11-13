# Guía de Despliegue en Dokploy

Este documento describe cómo desplegar el portafolio en Dokploy.

## Requisitos Previos

1. Cuenta en Dokploy
2. Repositorio Git (GitHub, GitLab, etc.)
3. Proyecto configurado con los archivos necesarios

## Archivos de Configuración

Este proyecto incluye los siguientes archivos para el despliegue:

- `Dockerfile`: Define la imagen Docker multi-stage (Node.js + Nginx)
- `dokploy.json`: Configuración específica de Dokploy
- `nginx.conf`: Configuración del servidor web Nginx
- `.dockerignore`: Archivos excluidos del build de Docker

## Pasos para Desplegar

### 1. Preparar el Repositorio

Asegúrate de que todos los cambios estén commiteados y pusheados a tu repositorio:

```bash
git add .
git commit -m "Configuración lista para Dokploy"
git push origin main
```

### 2. Crear Aplicación en Dokploy

1. Inicia sesión en tu panel de Dokploy
2. Crea una nueva aplicación
3. Selecciona "Dockerfile" como tipo de despliegue
4. Conecta tu repositorio Git

### 3. Configurar la Aplicación

#### Variables de Entorno

Configura las siguientes variables en Dokploy (ya están definidas en `dokploy.json`):

```
NODE_ENV=production
PORT=80
```

#### Puertos

- Puerto interno: `80`
- Puerto externo: `80` (o el que prefieras)
- Protocolo: `http`

#### Health Check

El proyecto incluye un health check en `/health` que:
- Intervalo: 30 segundos
- Timeout: 3 segundos
- Reintentos: 3

### 4. Recursos Recomendados

```
Memoria: 512Mi
CPU: 0.5 cores
```

Estos valores están configurados en `dokploy.json` y son adecuados para un sitio estático.

### 5. Iniciar Despliegue

1. Haz clic en "Deploy" en Dokploy
2. Espera a que se complete el build (puede tomar 2-5 minutos)
3. Verifica que el contenedor esté corriendo

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

### Error 502 Bad Gateway

Si encuentras un error 502:

1. Verifica que el contenedor esté corriendo: `docker ps`
2. Revisa los logs: `docker logs <container-id>`
3. Verifica el health check: `curl http://localhost/health`

### Build Fallido

Si el build falla:

1. Revisa los logs de build en Dokploy
2. Verifica que todas las dependencias estén en `package.json`
3. Asegúrate de que `npm run build` funcione localmente

### Contenedor no Inicia

Si el contenedor no inicia:

1. Verifica que Nginx esté configurado correctamente
2. Revisa los logs del contenedor
3. Verifica que los archivos estén en `/usr/share/nginx/html`

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
