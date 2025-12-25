// @ts-check
import tailwind from '@astrojs/tailwind';
import { defineConfig } from 'astro/config';
import { createLogger } from 'vite';

const logger = createLogger();
const customLogger = {
    ...logger,
    // @ts-ignore
    warn(msg, options) {
        // Filtrar warnings de imports no usados en node_modules de Astro
        if (msg.includes('node_modules/astro/') && msg.includes('never used')) {
            return;
        }
        logger.warn(msg, options);
    }
};

// https://astro.build/config
export default defineConfig({
    output: 'static',
    integrations: [tailwind()],
    vite: {
        customLogger,
        build: {
            rollupOptions: {
                onLog(level, log, handler) {
                    // Suprimir warning de imports no usados en módulos internos de Astro
                    if (log.code === 'UNUSED_EXTERNAL_IMPORT' &&
                        log.id?.includes('node_modules/astro/')) {
                        return;
                    }
                    handler(level, log);
                }
            }
        }
    }
});




