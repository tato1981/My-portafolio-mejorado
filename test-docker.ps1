# Script para probar el Dockerfile localmente
Write-Host "🚀 Probando build de Docker..." -ForegroundColor Cyan

# Build de la imagen
Write-Host "`n📦 Construyendo imagen Docker..." -ForegroundColor Yellow
docker build -t portafolio-test .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al construir la imagen" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Imagen construida exitosamente" -ForegroundColor Green

# Limpiar contenedor previo si existe
Write-Host "`n🧹 Limpiando contenedor previo..." -ForegroundColor Yellow
docker rm -f portafolio-test-container 2>$null

# Ejecutar contenedor
Write-Host "`n🐳 Iniciando contenedor..." -ForegroundColor Yellow
docker run -d -p 8080:80 --name portafolio-test-container portafolio-test

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error al iniciar el contenedor" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Contenedor iniciado exitosamente" -ForegroundColor Green

# Esperar que el contenedor inicie
Write-Host "`n⏳ Esperando que Nginx inicie..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Verificar logs
Write-Host "`n📋 Logs del contenedor:" -ForegroundColor Yellow
docker logs portafolio-test-container

# Verificar que responda
Write-Host "`n🔍 Probando conexión HTTP..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Sitio respondiendo correctamente (Status: $($response.StatusCode))" -ForegroundColor Green
    Write-Host "`n🌐 Abre tu navegador en: http://localhost:8080" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error al conectar: $_" -ForegroundColor Red
    Write-Host "`n📋 Logs completos:" -ForegroundColor Yellow
    docker logs portafolio-test-container
}

Write-Host "`n📝 Comandos útiles:" -ForegroundColor Cyan
Write-Host "  Ver logs:     docker logs -f portafolio-test-container"
Write-Host "  Detener:      docker stop portafolio-test-container"
Write-Host "  Eliminar:     docker rm -f portafolio-test-container"
Write-Host "  Limpiar todo: docker rm -f portafolio-test-container; docker rmi portafolio-test"
