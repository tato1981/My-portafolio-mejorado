# Guía de Deployment - Portafolio con Formulario Seguro

## Pre-requisitos

- Node.js 18 o superior instalado
- Firebase CLI instalado (`npm install -g firebase-tools`)
- Cuenta de Firebase configurada
- Cuenta de Hostinger con servicio SMTP

## Estructura del Proyecto

```
portafolio/
├── src/                    # Código fuente de Astro
├── functions/              # Firebase Cloud Functions
│   ├── index.js           # Función de envío de email
│   ├── package.json       # Dependencias de functions
│   └── .env              # Variables de entorno (NO commitable)
├── dist/                  # Build de producción (generado)
├── firebase.json          # Configuración de Firebase
└── astro.config.mjs       # Configuración de Astro
```

## Paso 1: Verificar Variables de Entorno

Asegúrate de que el archivo `functions/.env` existe y contiene:

```bash
SMTP_HOST=smtp.hostinger.com
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=edificio-calle-57@duberneydev.online
SMTP_PASSWORD=DuberneY.9958113
SMTP_FROM_EMAIL=edificio-calle-57@duberneydev.online
SMTP_FROM_NAME=Portafolio profesional
```

> **IMPORTANTE**: Asegúrate de que este archivo esté en `.gitignore` y NUNCA lo subas a Git.

## Paso 2: Instalar Dependencias

```bash
# Instalar dependencias del proyecto principal
npm install

# Instalar dependencias de Firebase Functions
cd functions
npm install
cd ..
```

## Paso 3: Build del Proyecto

```bash
# Compilar el sitio estático de Astro
npm run build
```

Esto generará la carpeta `dist/` con los archivos estáticos.

## Paso 4: Configurar Firebase (Primera vez)

Si es la primera vez que despliegas:

```bash
# Login en Firebase
firebase login

# Inicializar el proyecto (si no está inicializado)
firebase use --add

# Selecciona tu proyecto: duberneydevs
```

## Paso 5: Deploy a Firebase

### Opción A: Deploy Completo (Hosting + Functions)

```bash
firebase deploy
```

### Opción B: Deploy Solo Hosting

```bash
firebase deploy --only hosting
```

### Opción C: Deploy Solo Functions

```bash
firebase deploy --only functions
```

## Paso 6: Verificar el Deployment

1. **Accede a tu sitio**: https://duberneydevs.web.app
2. **Verifica la Cloud Function**:
   - Ve a Firebase Console → Functions
   - Deberías ver `sendContactEmail` en la lista
3. **Prueba el formulario**:
   - Ve a la sección de Contacto
   - Envía un mensaje de prueba
   - Verifica que llegue a tu buzón de Hostinger

## Paso 7: Monitorear Logs

```bash
# Ver logs de Firebase Functions en tiempo real
firebase functions:log

# Ver logs específicos de la función sendContactEmail
firebase functions:log --only sendContactEmail
```

O desde Firebase Console:
1. Ve a Firebase Console
2. Functions → Logs
3. Filtra por función `sendContactEmail`

## URLs Importantes

- **Sitio Web**: https://duberneydevs.web.app
- **Cloud Function**: https://us-central1-duberneydevs.cloudfunctions.net/sendContactEmail
- **Firebase Console**: https://console.firebase.google.com/project/duberneydevs

## Comandos Útiles

```bash
# Desarrollo local
npm run dev                    # Inicia servidor de desarrollo Astro
firebase emulators:start       # Inicia emuladores de Firebase (opcional)

# Build y Deploy
npm run build                  # Build del sitio
firebase deploy                # Deploy completo
npm run deploy                 # Build + Deploy (según package.json)

# Debugging
firebase functions:log         # Ver logs de functions
firebase hosting:channel:list  # Ver canales de hosting
```

## Solución de Problemas

### Problema: "Error: HTTP Error: 403, The caller does not have permission"

**Solución**: Verifica que tu usuario tiene permisos en el proyecto Firebase
```bash
firebase login --reauth
```

### Problema: La función no se despliega

**Solución**: Verifica que el archivo `functions/package.json` tenga todas las dependencias
```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

### Problema: Los emails no llegan

**Verificaciones**:
1. Revisa los logs: `firebase functions:log`
2. Verifica las credenciales SMTP en `functions/.env`
3. Verifica que el puerto 465 no esté bloqueado
4. Prueba las credenciales SMTP manualmente

### Problema: Error CORS en el formulario

**Solución**: Verifica que tu dominio está en la lista de `allowedOrigins` en `functions/index.js`:
```javascript
const allowedOrigins = [
  'https://duberneydevs.web.app',
  'https://duberneydevs.firebaseapp.com',
  // Agrega tu dominio personalizado aquí si tienes uno
];
```

### Problema: Rate limiting bloqueando usuarios legítimos

**Solución**: Ajusta los límites en `functions/index.js`:
```javascript
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // Aumenta la ventana de tiempo
  max: 5, // Aumenta el número de requests permitidos
  // ...
});
```

## Seguridad Post-Deployment

### Checklist de Seguridad

- [ ] Verifica que `.env` no está en el repositorio Git
- [ ] Prueba el honeypot (llena el campo "website" oculto)
- [ ] Prueba el rate limiting (envía 4+ mensajes rápidamente)
- [ ] Verifica headers de seguridad en https://securityheaders.com/
- [ ] Revisa los logs para detectar intentos sospechosos
- [ ] Cambia las credenciales SMTP si fueron expuestas

### Rotación de Credenciales

Si necesitas cambiar las credenciales SMTP:

1. Actualiza `functions/.env`
2. Vuelve a desplegar las functions:
   ```bash
   firebase deploy --only functions
   ```

## Mantenimiento

### Actualizaciones Mensuales

```bash
# Actualizar dependencias del proyecto principal
npm update
npm audit fix

# Actualizar dependencias de functions
cd functions
npm update
npm audit fix
cd ..

# Re-deploy después de actualizar
npm run build
firebase deploy
```

### Backup de Configuración

Es recomendable mantener un backup seguro de:
- `functions/.env` (en un gestor de contraseñas)
- `firebase.json`
- Configuración de Firebase Functions

## Costos Estimados

**Firebase Spark Plan (Gratis)**:
- Hosting: Hasta 10 GB de almacenamiento
- Functions: 2M invocaciones/mes gratis
- Bandwidth: 360 MB/día

**Estimación para tu portafolio**:
- Hosting: ~20-50 MB (muy por debajo del límite)
- Functions: Asumiendo 100 mensajes/mes = 100 invocaciones (muy por debajo del límite)
- **Costo total**: $0/mes (dentro del plan gratuito)

## Próximos Pasos Opcionales

1. **Dominio Personalizado**: Conecta tu propio dominio en Firebase Hosting
2. **reCAPTCHA**: Agrega Google reCAPTCHA v3 para protección adicional
3. **Analytics**: Configura Google Analytics para rastrear envíos de formularios
4. **Notificaciones**: Configura notificaciones push cuando llegue un mensaje
5. **Dashboard**: Crea un panel de administración para ver los mensajes

## Soporte

Si encuentras problemas:
1. Revisa los logs: `firebase functions:log`
2. Consulta la documentación de seguridad: `SECURITY.md`
3. Verifica Firebase Status: https://status.firebase.google.com/

---

**Última actualización**: ${new Date().toLocaleDateString('es-ES')}
