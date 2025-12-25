# Documentación de Seguridad - Formulario de Contacto

## Resumen de Implementación

Este documento detalla las medidas de seguridad implementadas en el formulario de contacto siguiendo las mejores prácticas de OWASP Top 10 (2021).

## Medidas de Seguridad Implementadas

### 1. A03:2021 - Injection Prevention (Prevención de Inyección)

#### Validación de Entrada
- **Validación del lado del servidor**: Todas las entradas se validan en Firebase Cloud Functions usando `validator.js`
- **Validación del lado del cliente**: HTML5 validation attributes (maxlength, minlength, pattern, type)
- **Sanitización HTML**: Uso de DOMPurify para eliminar cualquier código malicioso en HTML

#### Controles Implementados:
```javascript
// Validaciones específicas:
- Nombre: 2-100 caracteres, solo letras y espacios
- Email: Validación RFC 5322 + normalización
- Asunto: 5-200 caracteres
- Mensaje: 10-5000 caracteres (protección contra DoS)
```

#### Prevención de XSS:
- Todo el contenido del usuario se sanitiza antes de incluirse en el email
- Uso de `validator.escape()` para escapar HTML entities
- DOMPurify remueve tags peligrosos

### 2. A05:2021 - Security Misconfiguration (Configuración de Seguridad)

#### Headers de Seguridad (firebase.json):
```json
X-Content-Type-Options: nosniff          // Previene MIME sniffing
X-Frame-Options: DENY                     // Previene clickjacking
X-XSS-Protection: 1; mode=block          // Activa filtro XSS del navegador
Referrer-Policy: strict-origin-when-cross-origin  // Controla información de referrer
Permissions-Policy: geolocation=(), microphone=(), camera=()  // Restringe APIs del navegador
Strict-Transport-Security: max-age=31536000  // Fuerza HTTPS (en Cloud Function)
Content-Security-Policy: default-src 'self'  // Previene carga de recursos no autorizados
```

#### CORS Configurado Restrictivamente:
```javascript
// Solo permite requests desde:
- https://duberneydevs.web.app
- https://duberneydevs.firebaseapp.com
- localhost (solo en desarrollo)
```

#### Variables de Entorno:
- Credenciales SMTP almacenadas en `.env` (nunca en código)
- `.env` incluido en `.gitignore`
- Uso de Firebase Functions config para producción

#### TLS/SSL:
- SMTP usa puerto 465 con SSL
- TLS mínimo v1.2 configurado
- `rejectUnauthorized: true` para validar certificados

### 3. A07:2021 - Identification and Authentication Failures

#### Rate Limiting:
```javascript
// Límites configurados:
- 3 requests por IP cada 15 minutos
- Previene spam y ataques de fuerza bruta
```

#### Honeypot Anti-Bot:
```html
<!-- Campo invisible para humanos, visible para bots -->
<input type="text" name="website" style="position: absolute; left: -9999px;" />
```
- Si el campo "website" contiene datos, la request se rechaza automáticamente
- Se registra el intento en logs para análisis

### 4. A09:2021 - Security Logging and Monitoring Failures

#### Logging Implementado:

**Eventos Exitosos:**
```javascript
functions.logger.info('Email sent successfully', {
  messageId: info.messageId,
  from: email,
  subject: subject,
  ip: ip,
  timestamp: new Date().toISOString()
});
```

**Eventos Sospechosos:**
```javascript
// Bot detectado via honeypot
functions.logger.warn('Bot detected via honeypot field', { ip: ip });

// Validación fallida
functions.logger.warn('Validation failed', { errors: errors, ip: ip });

// Método HTTP inválido
functions.logger.warn('Invalid method attempted', { method: method, ip: ip });
```

**Errores:**
```javascript
functions.logger.error('Error sending email', {
  error: error.message,
  code: error.code,
  ip: ip,
  timestamp: new Date().toISOString()
});
```

> **Nota**: Los logs están disponibles en Firebase Console > Functions > Logs

### 5. Protección Adicional contra DoS

#### Límites de Tamaño:
- Nombre: máximo 100 caracteres
- Email: máximo 254 caracteres (RFC 5321)
- Asunto: máximo 200 caracteres
- Mensaje: máximo 5000 caracteres

#### Timeout de Conexión SMTP:
- Conexión SMTP se verifica antes de enviar
- Timeout implícito en nodemailer

### 6. Protección de Datos Sensibles

#### Credenciales:
- Nunca se exponen credenciales en el código
- `.env` protegido por `.gitignore`
- Variables de entorno en Firebase Functions

#### Email Reply-To:
- Los emails incluyen `replyTo: email` del remitente
- No se expone el email del usuario en logs públicos

## Arquitectura de Seguridad

```
Usuario (Frontend)
    ↓
[Validación HTML5]
    ↓
[Honeypot Check]
    ↓
Firebase Cloud Function
    ↓
[Headers de Seguridad + CORS]
    ↓
[Rate Limiting Check]
    ↓
[Validación y Sanitización]
    ↓
[Logging]
    ↓
Nodemailer + SMTP (SSL/TLS)
    ↓
Hostinger Mail Server
```

## Deployment y Configuración

### Variables de Entorno Requeridas:

En `functions/.env`:
```bash
SMTP_HOST=smtp.hostinger.com
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=tu-email@dominio.com
SMTP_PASSWORD=tu-password
SMTP_FROM_EMAIL=tu-email@dominio.com
SMTP_FROM_NAME=Nombre del Remitente
```

### Comandos de Deployment:

```bash
# Build del sitio estático
npm run build

# Deploy completo (hosting + functions)
firebase deploy

# Deploy solo hosting
firebase deploy --only hosting

# Deploy solo functions
firebase deploy --only functions
```

## Checklist de Seguridad Post-Deployment

- [ ] Verificar que las variables de entorno están configuradas correctamente
- [ ] Probar el formulario en producción
- [ ] Verificar que los emails se reciben correctamente
- [ ] Comprobar los logs en Firebase Console
- [ ] Verificar headers de seguridad con https://securityheaders.com/
- [ ] Probar rate limiting (intentar enviar 4+ mensajes rápidamente)
- [ ] Verificar que honeypot funciona (llenar campo "website" y enviar)
- [ ] Revisar que las credenciales no están en el repositorio de Git

## Mantenimiento Continuo

### Actualizaciones Recomendadas:
1. Mantener dependencias actualizadas mensualmente:
   ```bash
   npm audit
   npm audit fix
   ```

2. Revisar logs de Firebase periódicamente para detectar patrones sospechosos

3. Actualizar rate limits según tráfico real

4. Considerar implementar CAPTCHA si el spam aumenta (reCAPTCHA v3)

## Posibles Mejoras Futuras

1. **CAPTCHA**: Implementar Google reCAPTCHA v3 para protección adicional
2. **Rate Limiting Distribuido**: Usar Firestore para rate limiting más robusto
3. **Email Verification**: Verificar que el email del remitente existe (usando un servicio)
4. **Blacklist de IPs**: Bloquear automáticamente IPs que abusan del formulario
5. **WAF**: Considerar usar un Web Application Firewall (Cloudflare, etc.)
6. **2FA para Admin**: Si se agregan funcionalidades de administración

## Recursos Adicionales

- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Nodemailer Security](https://nodemailer.com/about/security/)

## Contacto de Seguridad

Si encuentras una vulnerabilidad de seguridad, por favor repórtala de manera responsable a través de los canales apropiados.

---

**Última actualización**: ${new Date().toLocaleDateString('es-ES')}
**Versión**: 1.0.0
