# 🚀 Mi Portafolio Personal

Portafolio web moderno desarrollado con Astro y Tailwind CSS, listo para desplegar en Netlify.

## ✨ Características

- 🎨 Diseño moderno con efectos visuales (partículas, gradientes animados)
- 📱 Totalmente responsive
- ⚡ Rendimiento optimizado con Astro
- 🎭 Animaciones suaves y transiciones
- 📧 Formulario de contacto con Netlify Forms
- 🌐 Preparado para producción

## 🛠️ Tecnologías

- **Framework**: Astro 5.13.11
- **Estilos**: Tailwind CSS 3.4.6
- **TypeScript**: 5.9.3
- **Formularios**: Netlify Forms
- **Hosting**: Netlify

## 📦 Instalación

```bash
# Instalar dependencias
npm install

# Desarrollo local
npm run dev

# Construir para producción
npm run build

# Vista previa de producción
npm run preview
```

## 🌐 Despliegue en Netlify

### Opción 1: Despliegue desde GitHub (Recomendado)

1. Sube tu código a GitHub
2. Ve a [Netlify](https://netlify.com)
3. Click en "Add new site" → "Import an existing project"
4. Conecta tu repositorio de GitHub
5. Configuración automática (Netlify detecta `netlify.toml`)
6. Click en "Deploy"
7. ¡Listo! Tu sitio estará en línea

### Opción 2: Despliegue CLI

```bash
# Instalar Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Desplegar
netlify deploy --prod
```

## 📧 Formulario de Contacto

El formulario está configurado con **Netlify Forms**:

- ✅ Sin backend necesario
- ✅ Anti-spam integrado (honeypot)
- ✅ Notificaciones por email
- ✅ Página de agradecimiento

### Configurar notificaciones:

1. Ve a tu sitio en Netlify
2. Settings → Forms → Form notifications
3. Añade tu email para recibir los mensajes

## 📂 Estructura del Proyecto

```
/
├── public/           # Assets estáticos
│   └── images/      # Imágenes
├── src/
│   ├── components/  # Componentes Astro
│   ├── layouts/     # Layouts
│   ├── pages/       # Páginas
│   │   ├── index.astro    # Página principal
│   │   └── gracias.astro  # Página de agradecimiento
│   ├── scripts/     # Scripts TypeScript
│   └── styles/      # Estilos globales
└── netlify.toml     # Configuración de Netlify
```

## 🎯 Secciones

- **Hero**: Presentación con efectos visuales
- **Sobre Mí**: Información personal y profesional
- **Servicios**: Servicios que ofrezco
- **Habilidades**: Stack tecnológico
- **Proyectos**: Portfolio de trabajos
- **Contacto**: Formulario funcional con Netlify Forms

## 🧞 Comandos

| Comando       | Acción                                    |
|:------------- |:----------------------------------------- |
| `npm install` | Instalar dependencias                     |
| `npm run dev` | Servidor local en `localhost:4321`        |
| `npm run build` | Construir sitio para producción en `./dist/` |
| `npm run preview` | Vista previa local antes de desplegar  |

## 📝 Personalización

Edita los siguientes archivos para personalizar tu portafolio:

- **src/components/Hero.astro** → Nombre y títulos
- **src/components/About.astro** → Información personal
- **src/components/Services.astro** → Servicios que ofreces
- **src/components/Skills.astro** → Tecnologías
- **src/components/Projects.astro** → Tus proyectos
- **src/components/Footer.astro** → Redes sociales y contacto

## 📝 Licencia

MIT - Siéntete libre de usar este proyecto como base para tu propio portafolio.

## 👤 Autor

Desarrollado con ❤️ para mostrar mis habilidades y proyectos.
