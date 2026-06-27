# CASEI Tutorías

Aplicación Flutter para visualizar la segmentación académica no supervisada del ecosistema CASEI.

## Arquitectura

Sigue la misma arquitectura usada en TaskFlow:

- Clean Architecture por feature.
- Screaming Architecture.
- Vertical Slicing.
- MVVM con `Provider`.
- Inyección manual con `get_it`.
- Cliente HTTP encapsulado con `http`.
- Persistencia ligera de sesión con `shared_preferences`.
- Material Design 3.

## Estructura principal

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── http/
│   ├── storage/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── segmentation/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── app.dart
├── injection_container.dart
└── main.dart
```

## Estado actual

La app usa datos mock equivalentes a la salida actual del microservicio:

- Regular / seguimiento preventivo
- Atípico / buen promedio con baja asistencia
- Crítico / rezago alto
- Riesgo académico moderado

## Ejecutar

```bash
flutter pub get
flutter run
```

## Verificar

```bash
flutter analyze
flutter test
```
