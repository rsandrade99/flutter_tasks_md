# flutter_tasks_md

Proyecto Flutter para gestionar tareas personales, con arquitectura limpia y uso de Hive para almacenamiento local.

## Comenzando

Este proyecto es un punto de partida para una aplicación Flutter enfocada en la gestión de tareas.

### Requisitos

- Flutter SDK instalado (versión estable recomendada)
- Conexión a internet para descargar dependencias

### Instalación

Entra al directorio del proyecto:
```bash
cd flutter_tasks_md
```

Instala las dependencias:
```bash
flutter pub get
```

Genera los adapters de Hive:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Estructura del proyecto
- features/home/data: Implementaciones de repositorios y fuentes de datos.
- features/home/domain: Entidades, repositorios abstractos y casos de uso.
- features/home/presentation: UI, controladores y widgets reutilizables.
- main.dart: Punto de entrada de la app con configuración de rutas y tema.


## Autor

**Robert Andrade**  
Ingeniero en Tecnologías de Información  
Desarrollador Flutter especializado en arquitectura escalable, diseño profesional y experiencia de usuario.
- [GitHub](https://github.com/rsandrade99) 
- [LinkedIn](https://www.linkedin.com/in/rsandradea99/) 
- rsandradea@gmail.com
- [Instagram](https://www.instagram.com/robert_0899/)
