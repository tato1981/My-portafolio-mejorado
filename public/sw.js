/*
  Service Worker Dummy File
  This file is created to solve the 404 error in the console.
  It is likely that a previous project on this domain/port registered a service worker.
*/

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    self.registration.unregister()
      .then(() => self.clients.matchAll())
      .then((clients) => {
        clients.forEach(client => client.navigate(client.url));
      })
  );
});
