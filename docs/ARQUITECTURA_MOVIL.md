# Arquitectura móvil de CACEI

La aplicación está escrita en Flutter. Por ello, el equivalente del árbol nativo
Android se encuentra dentro de `lib/`; `android/app/src/main` conserva únicamente
el host y los puentes Kotlin necesarios para ejecutar Flutter en Android.

```text
lib/
|-- core/
|   |-- common_components/  # UI reutilizable por más de una funcionalidad
|   |-- constants/          # Configuración y constantes globales
|   |-- errors/             # Excepciones compartidas
|   |-- network/            # Cliente HTTP base
|   |-- security/           # Controles de seguridad transversales
|   |-- storage/            # Adaptadores de almacenamiento compartidos
|   |-- theme/              # Tema, colores y design system
|   `-- util/               # Estados y utilidades independientes
|-- navigation/
|   |-- app_navigator.dart  # Clave global de navegación
|   |-- app_router.dart     # Grafo y construcción de pantallas
|   `-- app_screen.dart     # Rutas disponibles
|-- features/
|   |-- auth/
|   |   |-- data/
|   |   |-- domain/
|   |   `-- presentation/
|   |       |-- components/
|   |       |-- screens/
|   |       `-- viewmodels/
|   |-- security/
|   |   |-- data/
|   |   |-- domain/
|   |   `-- presentation/
|   |       |-- screens/
|   |       `-- viewmodels/
|   |-- segmentation/
|   |   |-- data/
|   |   |-- domain/
|   |   `-- presentation/
|   |       |-- components/
|   |       |-- models/
|   |       |-- screens/
|   |       `-- viewmodels/
|   `-- tutor_navigation/
|       `-- presentation/
|           |-- components/
|           |-- models/
|           `-- viewmodels/
|-- app.dart                # MaterialApp y contenedor global
|-- injection_container.dart# Registro de dependencias
`-- main.dart               # Inicialización y punto de entrada
```

## Reglas de dependencias

- `domain` contiene entidades, contratos de repositorio y casos de uso; no depende
  de Flutter, Supabase ni de detalles de interfaz.
- `data` implementa contratos de `domain` y concentra DTO, mappers y fuentes de
  datos.
- `presentation` consume casos de uso o contratos de `domain` mediante view models.
- `core` solo aloja piezas transversales que pueden ser utilizadas por varias
  funcionalidades.
- Las rutas se declaran una vez en `AppScreen` y se construyen en `AppRouter`.
- El código Kotlin bajo `android/` no contiene pantallas de negocio; solo integra
  capacidades nativas requeridas por Flutter.
