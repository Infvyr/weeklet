---
name: Create Feature
description: Scaffolds a new feature following Clean Architecture conventions.
---

# Create Feature Skill

Follow these steps to implement a new feature in Weeklet (e.g., `Budget`, `Savings`).

## 1. Domain Layer (The Core)

Start here to define business logic.

1.  **Entity**: Create `lib/domain/entities/<feature>.dart`.
2.  **Repository Interface**: Create `lib/domain/repositories/<feature>_repository.dart`.
3.  **Use Cases**: Create `lib/domain/usecases/<feature>/` and add necessary files:
    - `add_<feature>_use_case.dart`
    - `get_<feature>_use_case.dart`
    - etc.

## 2. Data Layer (The Wiring)

Implement the interface.

1.  **Model**: Create `lib/data/models/<feature>_model.dart` (Annotate with `@HiveType`).
    - Implement `fromEntity` and `toEntity` methods.
2.  **Data Source**: Create `lib/data/datasources/local/<feature>_local_data_source.dart`.
3.  **Repository Impl**: Create `lib/data/repositories/<feature>_repository_impl.dart`.

## 3. Presentation Layer (The UI)

Connect it to the user.

1.  **BLoC**: Create `lib/presentation/blocs/<feature>/`.
    - `<feature>_event.dart`
    - `<feature>_state.dart`
    - `<feature>_bloc.dart` (Inject use cases).
2.  **Screen**: Create `lib/presentation/screens/<feature>/<feature>_screen.dart`.
3.  **Widgets**: Create `lib/presentation/screens/<feature>/widgets/`.

## 4. Dependency Injection

1.  Register all classes in `lib/core/di/service_locator.dart`.
    - Order: Data Source -> Repository -> Use Cases -> BLoC.

## 5. Finalize

1.  Run the build runner to generate Hive adapters:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
