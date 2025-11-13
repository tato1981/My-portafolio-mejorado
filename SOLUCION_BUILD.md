# Solución de Errores de Build - Portfolio Astro

## Problema Original
El proyecto fallaba al ejecutar `npm run build` en Dokploy con los siguientes errores:
- No se podía encontrar el módulo `@tailwindcss/vite`
- Conflictos de versiones entre dependencias
- Sintaxis incorrecta de importación de Tailwind CSS

## Cambios Realizados

### 1. Actualización de `package.json`
**Antes:**
```json
"dependencies": {
  "@tailwindcss/vite": "^4.1.13",
  "astro": "^5.13.11",
  "tailwindcss": "^4.1.13"
}
```

**Después:**
```json
"dependencies": {
  "astro": "^5.13.11",
  "@astrojs/tailwind": "^6.0.2",
  "tailwindcss": "^3.4.6",
  "postcss": "^8.4.23",
  "autoprefixer": "^10.4.14"
}
```

**Motivo:** `@astrojs/tailwind` v6.x es compatible con Astro v5.x. Las versiones anteriores no eran compatibles.

### 2. Actualización de `astro.config.mjs`
**Antes:**
```javascript
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'astro/config';

export default defineConfig({
  output: 'static',
  vite: {
    plugins: [tailwindcss()]
  }
});
```

**Después:**
```javascript
import tailwind from '@astrojs/tailwind';
import { defineConfig } from 'astro/config';

export default defineConfig({
  output: 'static',
  integrations: [tailwind()],
});
```

**Motivo:** Usar la integración oficial de Astro para Tailwind en lugar de un plugin Vite personalizado.

### 3. Creación de `tailwind.config.cjs`
```javascript
module.exports = {
  content: [
    './src/**/*.{astro,html,js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
```

### 4. Creación de `postcss.config.cjs`
```javascript
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

### 5. Corrección de `src/styles/global.css`
**Antes:**
```css
@import "tailwindcss";
```

**Después:**
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;
```

**Motivo:** La sintaxis `@import "tailwindcss"` no es válida para Tailwind CSS v3. Se deben usar las directivas estándar `@tailwind`.

## Comandos para Desplegar

### Localmente
```powershell
# Instalar dependencias
npm ci

# Construir el proyecto
npm run build

# Previsualizar el build
npm run preview
```

### En Dokploy
1. Haz commit y push de los cambios:
```powershell
git add .
git commit -m "fix: corregir configuración de Tailwind para Astro 5"
git push origin main
```

2. En Dokploy, el proceso de build automático debería funcionar con la configuración actual en `dokploy.json`:
```json
{
  "name": "my-portafolio",
  "buildType": "static",
  "publishDirectory": "dist",
  "buildCommand": "npm run build",
  "installCommand": "npm install"
}
```

### Usando Docker (Opcional)
```powershell
# Construir el proyecto
npm run build

# Iniciar con Docker Compose
docker-compose up -d
```

El sitio estará disponible en `http://localhost` (puerto 80).

## Verificación del Build
Después de ejecutar `npm run build`, deberías ver:
```
✓ Completed in [tiempo]
✓ built in [tiempo]
✓ Completed in [tiempo]
[build] 2 page(s) built in [tiempo]
[build] Complete!
```

La carpeta `dist/` debe contener:
- `index.html` (página principal)
- `gracias/` (página de gracias)
- `_astro/` (assets compilados)
- `images/` (imágenes públicas)

## Notas Importantes
- **Node.js:** Asegúrate de usar Node.js 18+ para compatibilidad con Astro 5
- **Dokploy:** Si usas variables de entorno, verifica que `NODE_ENV` no esté en `production` o que instale todas las dependencias necesarias
- **Docker:** La imagen base de Node debe ser compatible (ej: `node:18-alpine` o superior)

## Troubleshooting

### Si el build sigue fallando en Dokploy:
1. Verifica los logs completos del build en Dokploy
2. Asegúrate de que Node.js >= 18 esté disponible
3. Verifica que `npm install` instale todas las dependencias (no solo production)
4. Si es necesario, agrega `--legacy-peer-deps` al comando de instalación en `dokploy.json`:
   ```json
   "installCommand": "npm install --legacy-peer-deps"
   ```

### Si hay problemas con estilos:
- Verifica que `tailwind.config.cjs` incluya todas las rutas de tus archivos
- Revisa que `postcss.config.cjs` esté en la raíz del proyecto
- Asegúrate de que las directivas `@tailwind` estén al principio de `global.css`
