// Archivo de configuración para variables de entorno
// Astro automáticamente carga las variables que empiezan con PUBLIC_

export const config = {
  // Información Personal
  name: import.meta.env.PUBLIC_NAME || 'Duberney Obando Cano',
  email: import.meta.env.PUBLIC_EMAIL || 'duberney22915@gmail.com',
  phone: import.meta.env.PUBLIC_PHONE || '+57 3145716188',
  location: import.meta.env.PUBLIC_LOCATION || 'Colombia',

  // Redes Sociales
  social: {
    github: import.meta.env.PUBLIC_GITHUB_URL || 'https://github.com/tu-usuario',
    linkedin: import.meta.env.PUBLIC_LINKEDIN_URL || 'https://linkedin.com/in/tu-usuario',
    youtube: import.meta.env.PUBLIC_YOUTUBE_URL || 'https://youtube.com/tu-canal',
    twitter: import.meta.env.PUBLIC_TWITTER_URL || 'https://x.com/tu-usuario',
    instagram: import.meta.env.PUBLIC_INSTAGRAM_URL || 'https://instagram.com/tu-usuario',
  },

  // Títulos Profesionales (para el typewriter)
  titles: [
    import.meta.env.PUBLIC_TITLE_1 || 'Tecnólogo Análisis y Desarrollo de Software',
    import.meta.env.PUBLIC_TITLE_2 || 'Desarrollador de Software',
    import.meta.env.PUBLIC_TITLE_3 || 'Especialista en Ciberseguridad',
  ],

  // Certificaciones
  certifications: {
    certjoin: import.meta.env.PUBLIC_CERT_CERTJOIN_URL || 'https://campus.certjoin.com/mod/customcert/verify_certificate.php',
    hacking: import.meta.env.PUBLIC_CERT_HACKING_URL || 'https://www.ucatalunya.edu.co/diplomados/hacking-etico',
    senatec: import.meta.env.PUBLIC_CERT_SENATEC_URL || '#',
  },
};
