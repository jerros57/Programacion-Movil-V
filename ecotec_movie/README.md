# ecotec_movie - Cartelera de Cine Móvil

Aplicación móvil desarrollada en Flutter para la visualización de la cartelera de cine en tiempo real, consumiendo la API REST de **The Movie Database (TMDB)**.

---

## 👨‍💻 Datos del Autor

- **Autor:** Jeremy Molina Sánchez
- **Carrera:** Ingeniería en Sistemas Inteligentes
- **Institución:** Universidad ECOTEC
- **Año:** 2026
- **Asignatura:** Programación Móvil V
- **Actividad:** Actividad Integradora 3 – Integración de API, Modelos de Datos y Gestión de Estado

---

## 🌐 Especificaciones de la API

La aplicación se conecta a los servicios de **The Movie Database (TMDB) API v3** para consultar información actualizada del catálogo cinematográfico mundial.

- **Servicio:** The Movie Database (TMDB)
- **Base URL:** `https://api.themoviedb.org`
- **Endpoint consumido:** `/3/movie/now_playing`
- **Método HTTP:** `GET`
- **Parámetros de consulta:**
  - `api_key`: Clave de autenticación para desarrolladores de TMDB.
  - `language`: `es-ES` (obtiene sinopsis, títulos y metadatos en español).
  - `page`: `1` (primer conjunto paginado de resultados).

### Modelos de Dominio en Dart

Se implementó una capa de modelos desacoplada y fuertemente tipada dentro del directorio `lib/models/`:

1. **`Movie` (`lib/models/movie.dart`)**:
   - Modela individualmente cada película del catálogo.
   - **Propiedades:** `id` (`int`), `title` (`String`), `overview` (`String`), `posterPath` (`String?`), `voteAverage` (`double`), `releaseDate` (`String`).
   - **Manejo defensivo de tipos:** Conversión segura de valores numéricos `vote_average` mediante `(json['vote_average'] as num?)?.toDouble()` para prevenir discrepancias entre enteros y decimales devueltos por la API.
   - **Getters de imagen:**
     - `fullPosterImg`: Construye la URL completa `https://image.tmdb.org/t/p/w500$posterPath` con resolución estándar de 500px, retornando un placeholder alternativo en caso de ser nulo o vacío.
     - `fullPosterUrl`: Alias de conveniencia hacia `fullPosterImg`.
   - **Serialización:** Métodos `fromJson()`, `fromRawJson()`, `toJson()` y `toRawJson()`.

2. **`NowPlayingResponse` (`lib/models/now_playing_response.dart`)**:
   - Modela la respuesta raíz paginada del endpoint `/now_playing`.
   - **Propiedades:** `page` (`int`), `results` (`List<Movie>`), `totalPages` (`int`), `totalResults` (`int`).
   - **Serialización:** Mapeo automático de colecciones dinámicas a instancias de `Movie`.

3. **`models.dart` (`lib/models/models.dart`)**:
   - Barrel file que centraliza las exportaciones de la capa de datos.

---

## 🏗️ Arquitectura y Gestión de Estado

El proyecto implementa el patrón **Provider** con `ChangeNotifier` para garantizar un desacoplamiento estricto entre la lógica de negocio, el consumo de red y la capa de presentación (UI).

### 1. Máquina de Estados Reactiva (`MovieLoadingState`)
El provider principal (`MoviesProvider`) expone un enumerador de tres estados que rige el árbol de widgets:

```dart
enum MovieLoadingState {
  loading, // Petición en curso
  success, // Datos cargados correctamente
  error,   // Fallo de red, timeout o error HTTP
}
```

- **`MovieLoadingState.loading`**: Renderiza un `CircularProgressIndicator` centrado con un mensaje informativo (`'Cargando cartelera...'`).
- **`MovieLoadingState.error`**: Renderiza una vista con icono de alerta (`Icons.wifi_off_rounded`), mensaje explicativo del problema (`errorMessage`) y un botón interactivo `ElevatedButton.icon` (**Reintentar**) que reinicia la consulta.
- **`MovieLoadingState.success`**: Renderiza el carrusel principal (`CardSwiper`) y el carrusel horizontal (`MovieSlider`) con las películas reales obtenidas.

### 2. Resiliencia y Manejo de Excepciones de Red
La consulta HTTP cuenta con un límite de tiempo estricto (`.timeout(const Duration(seconds: 10))`) y captura granular de excepciones:
- `SocketException`: Sin conexión a internet o sin resolución DNS.
- `http.ClientException`: Anomalías a nivel del cliente HTTP.
- `TimeoutException`: Servidor no responde dentro del umbral de 10 segundos.
- `catch (e)` genérico: Fallos inesperados durante la ejecución.
- Respuestas HTTP no 200: Detección y reporte del código de estado devuelto por el servidor.
- Bloque `finally`: Ejecución garantizada de `notifyListeners()` para asegurar la reactividad visual en cualquier desenlace.

### 3. Mecanismo Pull-to-Refresh
El cuerpo de la pantalla principal (`HomeScreen`) está envuelto en un widget `RefreshIndicator`, permitiendo a los usuarios recargar manualmente la cartelera deslizando hacia abajo en cualquier momento. Todos los contenedores soportan `AlwaysScrollableScrollPhysics` para asegurar que el gesto de refresco responda incluso cuando la pantalla esté vacía o en estado de error.

---

## 🚀 Instrucciones de Ejecución

Sigue estos pasos para compilar y ejecutar el proyecto localmente en tu entorno de desarrollo:

### Prerrequisitos
- Flutter SDK (versión 3.13.2 o superior)
- Dart SDK
- Google Chrome (para ejecución Web) o un Emulador / Dispositivo Android/iOS físico configurado.

### 1. Clonar el repositorio y acceder a la carpeta del proyecto
```bash
git clone <URL_DEL_REPOSITORIO>
cd Programacion-Movil-V/ecotec_movie
```

### 2. Instalar dependencias
Descarga todos los paquetes y dependencias registradas en el `pubspec.yaml`:
```bash
flutter pub get
```

### 3. Verificación de análisis estático (Linter)
Valida que el código cumpla con los estándares de calidad de Flutter (0 errores, 0 advertencias):
```bash
flutter analyze
```

### 4. Ejecución en Web (Google Chrome)
Para desplegar la aplicación en el navegador con soporte de renderizado web:
```bash
flutter run -d chrome
```

### 5. Ejecución en Móvil (Emulador / Dispositivo físico)
Para correr en el emulador por defecto o dispositivo conectado por depuración USB:
```bash
flutter run
```
*(Si hay múltiples dispositivos conectados, puedes listar sus identificadores con `flutter devices` y ejecutar `flutter run -d <DEVICE_ID>`)*.
