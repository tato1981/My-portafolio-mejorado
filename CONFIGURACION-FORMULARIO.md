# 📧 Configuración del Formulario de Contacto

Tienes **3 opciones** para recibir los mensajes del formulario en tu email **duberney22915@gmail.com** sin necesidad de backend.

---

## ✅ **Opción 1: Formspree** (Recomendada - Más Fácil)

### Pasos:

1. **Ve a [Formspree.io](https://formspree.io/)**
2. **Regístrate gratis** con tu email
3. **Crea un nuevo formulario**:
   - Click en "New Form"
   - Nombre: `Portafolio Contacto`
   - Email: `duberney22915@gmail.com`
4. **Copia el Form ID** que te dan (ejemplo: `xyzabc123`)
5. **Actualiza el archivo `src/components/Contact.astro`**:
   
   Busca esta línea (aproximadamente línea 67):
   ```html
   action="https://formspree.io/f/YOUR_FORM_ID"
   ```
   
   Reemplaza `YOUR_FORM_ID` con tu ID real:
   ```html
   action="https://formspree.io/f/xyzabc123"
   ```

6. **¡Listo!** Los mensajes llegarán a `duberney22915@gmail.com`

### Ventajas:
- ✅ Gratis hasta 50 mensajes/mes
- ✅ Configuración en 2 minutos
- ✅ Anti-spam incluido
- ✅ Confirmación automática al remitente
- ✅ No requiere configuración en Netlify

---

## ✅ **Opción 2: Netlify Forms** (Requiere configuración post-deploy)

### Pasos:

1. **Despliega tu sitio en Netlify** (el formulario ya está configurado)
2. **Ve a tu sitio en Netlify Dashboard**
3. **Settings → Forms → Form notifications**
4. **Click en "Add notification"**
5. **Selecciona "Email notification"**
6. **Ingresa tu email**: `duberney22915@gmail.com`
7. **Selecciona el formulario**: `contact`
8. **Guarda**

### Ventajas:
- ✅ Gratis hasta 100 mensajes/mes
- ✅ Integrado con Netlify
- ✅ Panel de administración de mensajes
- ✅ Anti-spam incluido

### Desventaja:
- ⚠️ Requiere tener el sitio desplegado en Netlify primero

---

## ✅ **Opción 3: EmailJS** (Más personalizable)

### Pasos:

1. **Ve a [EmailJS.com](https://www.emailjs.com/)**
2. **Regístrate gratis**
3. **Conecta tu cuenta de Gmail**:
   - Email Services → Add New Service → Gmail
   - Autoriza tu cuenta `duberney22915@gmail.com`
4. **Crea una plantilla de email**:
   - Email Templates → Create New Template
   - Usa las variables: `{{from_name}}`, `{{message}}`, etc.
5. **Obtén tus credenciales**:
   - Service ID
   - Template ID
   - Public Key
6. **Actualiza `src/components/Contact.astro`**:

   Reemplaza el formulario con este código:

```html
<form id="contact-form" class="space-y-6">
  <!-- ... campos del formulario ... -->
  <button type="submit" id="submit-btn">Enviar Mensaje</button>
</form>

<script>
  // Importar EmailJS
  import emailjs from '@emailjs/browser';

  emailjs.init('TU_PUBLIC_KEY');

  document.getElementById('contact-form').addEventListener('submit', function(e) {
    e.preventDefault();
    
    emailjs.sendForm('TU_SERVICE_ID', 'TU_TEMPLATE_ID', this)
      .then(() => {
        alert('¡Mensaje enviado con éxito!');
        window.location.href = '/gracias';
      }, (error) => {
        alert('Error al enviar el mensaje');
      });
  });
</script>
```

### Ventajas:
- ✅ Muy personalizable
- ✅ Plantillas de email customizables
- ✅ Gratis hasta 200 mensajes/mes

### Desventaja:
- ⚠️ Requiere más configuración
- ⚠️ Necesita instalar dependencia

---

## 🎯 **Recomendación**

### Para empezar rápido:
**Usa Formspree** - Solo necesitas copiar el Form ID y listo.

### Si ya vas a usar Netlify:
**Usa Netlify Forms** - Está incluido y no necesitas servicios externos.

### Si quieres más control:
**Usa EmailJS** - Puedes personalizar los emails como quieras.

---

## 📝 **Configuración Actual**

Tu formulario ya está parcialmente configurado para Formspree. Solo falta:

1. Ir a Formspree.io
2. Crear tu formulario
3. Copiar el Form ID
4. Reemplazar `YOUR_FORM_ID` en `src/components/Contact.astro` línea 67

---

## 🔒 **Seguridad**

Todas las opciones incluyen:
- ✅ Protección anti-spam
- ✅ Validación de campos
- ✅ Rate limiting
- ✅ Sin exponer tu email directamente en el código

---

## ❓ **Problemas Comunes**

### Los mensajes no llegan:
1. Verifica que el email esté bien escrito
2. Revisa la carpeta de spam
3. Confirma que el Form ID sea correcto
4. Verifica que la cuenta esté verificada

### Error de CORS:
- Formspree y Netlify Forms manejan esto automáticamente
- EmailJS requiere configurar el dominio en su panel

---

**Última actualización**: 2025-11-15
