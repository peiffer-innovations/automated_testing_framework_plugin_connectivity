'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"main.dart.js": "fd6b57b152fa3d5ddf4b4b0f01eec4dc",
"assets/AssetManifest.json": "995e68f87ebc3e1caca404c0c3a840e4",
"assets/assets/tests/connectivity.json": "91ea934e32ff0066f763b65484507d2d",
"assets/assets/all_tests.json": "007825d26b802643980adb4d8209174f",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/packages/automated_testing_framework_example/assets/tests/slidables.json": "0e6ecffce2e4fe788c9f7a00e1a7d4e7",
"assets/packages/automated_testing_framework_example/assets/tests/double_tap.json": "35a920944da4cf2e2154bf1c138c2e34",
"assets/packages/automated_testing_framework_example/assets/tests/failure.json": "8cefd140b688b564169ed2d304a52ce8",
"assets/packages/automated_testing_framework_example/assets/tests/icons_gesture.json": "655cf20202457e9a9b8692f05334fbc8",
"assets/packages/automated_testing_framework_example/assets/tests/interpolated_variables.json": "2491e0da34265345c86a6fe89a089894",
"assets/packages/automated_testing_framework_example/assets/tests/stacked_scrolling.json": "bccfd950e4e01b7b3a0056ef42fefe93",
"assets/packages/automated_testing_framework_example/assets/tests/buttons.json": "0980eeed758c9091b9fe476bbe3aae34",
"assets/packages/automated_testing_framework_example/assets/tests/exit_app.json": "358f6cab447478d73eea4127678106ac",
"assets/packages/automated_testing_framework_example/assets/tests/theme.json": "5b72a996ff15d64d58b7627f29df05bb",
"assets/packages/automated_testing_framework_example/assets/tests/accessibility.json": "c98acf550ea22677d4adfa3016b120f8",
"assets/packages/automated_testing_framework_example/assets/tests/variables.json": "76229a7fbac5b3c9112db7be4192b142",
"assets/packages/automated_testing_framework_example/assets/tests/issue_5.json": "21c374a01729bf635c57bc9effc9d37b",
"assets/packages/automated_testing_framework_example/assets/tests/dropdowns.json": "f1f2f78f6bbb729048728e05abca6d41",
"assets/packages/automated_testing_framework_example/assets/tests/screenshot.json": "5a070f35d91e2c1cde99395809a1d876",
"assets/packages/automated_testing_framework_example/assets/all_tests.json": "a7f872805bad1d3e33860470000d69e3",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/NOTICES": "cda3bb749f159d1e6b1d2dc73ac2120f",
"flutter.js": "eb2682e33f25cd8f1fc59011497c35f8",
"index.html": "e27288c2e407d25db3fc98917ba34484",
"/": "e27288c2e407d25db3fc98917ba34484",
"favicon.png": "b72ecb27b88d0f05d623684a8ea894e8",
"version.json": "fbef46a3148011f918997b69198fa2ba",
"manifest.json": "15f73b7e8a8209c2206210b3ac8dea1b",
"icons/Icon-192.png": "478b7a2438d6842fb2d59eaafecc230b",
"icons/Icon-512.png": "97bf386e3ad9dfe2e1fdb14fa0e39009"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
