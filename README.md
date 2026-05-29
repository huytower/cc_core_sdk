# Flutter Get Starter Template

A modular starter kit built around **Clean Architecture** and **SOLID** principles. Designed to help junior and new developers find the right entry points, understand module boundaries, and extend the app safely.

## Development Requirements

- **Flutter:** 3.41.9 or higher
- **Dart:** 3.11.5 or higher  
- **Melos:** 7.8.0 (workspace version)
- **Code Generation:** Required for Hive adapters, JSON serialization, DI setup

## Quick start for new developers

1. Read `docs/AI_CONTEXT.md` for architecture overview and project intent.
2. Ensure you have Flutter 3.41.9+ and Dart 3.11.5+ installed
3. Run `melos bootstrap` to set up the workspace
4. Run `melos run gen` to generate code for Hive adapters, JSON serialization, etc.
5. Open `lib/main.dart` to follow app startup and feature wiring.
6. Inspect `lib/core/di/di.dart` for global dependency registration.
7. Explore `modules/` for app-specific domain/data modules.
8. Explore `libraries/features/lib/export_features.dart` for reusable feature packages.
9. Read `docs/onboarding.md` for step-by-step developer onboarding.
10. Use `docs/CONTRIBUTING.md` for workflow, code review, and documentation sync rules.

## Development Workflow

```bash
# Bootstrap the workspace
melos bootstrap

# Generate code (after adding new models, adapters, or DI annotations)
melos run gen

# Run analysis
melos run analyze

# Run tests
melos run test

# Clean and rebuild
melos clean
melos bootstrap
melos run gen
```

## CI/CD Setup

This project uses **Melos 7.x.x** with pub workspaces for monorepo management. The CI/CD pipeline requires:

1. **Flutter 3.41.9+** with Dart 3.11.5+ for workspace compatibility
2. **Code generation** runs before analysis to ensure generated files are available
3. **Generated files** are committed for app_config and data modules (.g.dart files)
4. **Analysis rules** configured for generated file compatibility

### CI Configuration

- **Workspace:** Melos 7.x.x pub workspaces (no melos.yaml, uses pubspec.yaml workspace config)
- **Global Melos activation:** Required for script compatibility in CI
- **Generated files:** Selected modules commit generated files for analysis
- **Lint rules:** `prefer_relative_imports` disabled for generated files

## Project Structure templates enable you to capture and re-use the structure and content of existing
projects, including :

    - project pages,
    - custom tracker fields,
    - and work flow definitions,

to speed new project creation and standardize lifecycle processes.

## Documents

Main technologies was used in this project structure.

1. [Dependency Injection in dart](https://medium.com/zipper-studios/dependency-injection-in-flutter-using-inject-dart-package-20d6a5918a5)
   [More References](https://viblo.asia/p/flutter-dependency-injection-di-that-don-gian-voi-get-it-va-injectable-naQZRLkP5vx)

**Dependency Injection using GetIt + Injectable :**
Allows us to focus on logic and not worry how we are going to access it.

    ![alt text](https://blog.pragmaticengineer.com/content/images/2021/04/Screenshot-2021-04-30-at-12.41.10.png)

## Libraries & Tools Used

- [melos](https://pub.dev/packages/melos) - Monorepo management with pub workspaces
- [getx](https://pub.dev/packages/get)
- [bloc](https://pub.dev/packages/bloc)

- [get_it](https://pub.dev/packages/get_it)

- [retrofit](https://pub.dev/packages/retrofit)

- [injectable](https://pub.dev/packages/injectable)
- [floor](https://pub.dev/packages/floor)
- [hive_box](https://pub.dev/packages/hive)
- [hive_ce](https://pub.dev/packages/hive_ce)

- [flutter_hooks](https://pub.dev/packages/flutter_hooks)

- [analyzer](https://pub.dev/packages/analyzer)
- [lint](https://pub.dev/packages/lint)

- [build_runner](https://pub.dev/packages/build_runner)
- [json_serializable](https://pub.dev/packages/json_serializable)

### Explanation

##### Build Runner

Allow us to run our generators during development.

    pub run build_runner **<command>**

<br>
where <command> can be one of these :<br>

    build: run a single build and exit<br>
    watch: runs a daemon that will run on file changes and rebuilds if necessary<br>
    serve: similar to watch, but also runs as a development server<br>
    test: for testing purposes

Most popular command line :

    flutter pub run build_runner build

##### Json Serializable

Allow you to make regular classes serializable by using annotations, an automated source code
generator that generates the JSON serialization boilerplate.

***user.dart***

```
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(this.name, this.email);

  String name;
  String email;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

```

##### Injectable

It's totally effectively when using combine with `get_it` library as a convenient code generator.

Injectable generates code that we would have otherwise written by using annotations. This allows us
to worry more about logic and less about how we are going to access it.

The *injectable* uses code generation and is based on these annotations :

    1. @injectable : Marks a class as an injectable dependency and generate.
    Most using with model, data .v.v.

        /// `Ex.`
        @injectable
        abstract class ICounterRepository {
            int getIncrement();
        }

        @injectable
        class CounterRepository implements ICounterRepository {
            @override
            int getIncrement() => 1;
        }

        @injectable
        class CounterChangeNotifier extends ChangeNotifier {
            final ICounterRepository _counterRepository;

            CounterChangeNotifier(this._counterRepository);
        }

        void main() {
            configureInjection(Env.prod);
            runApp(MyApp());
        }

        class MyApp extends StatelessWidget {
            @override
            Widget build(BuildContext context) {
                return MaterialApp(
                     title: 'Material App',
                     home: ChangeNotifierProvider(
                       create: (_) => getIt<CounterChangeNotifier>(),
                       child: CounterPage(),
                     ),
                );
            }
        }

    2. @module : Annotates a class as a collection of providers for dependency injection.
    Most using for feature, 3rd library, .v.v.
    3. @preResolve : pre-await the future and register its resolved value.

        /// `Ex.`
        @module
        abstract class RegisterModule {
            @preResolve
            Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
        }

    4. @named : automatically assign the implementation class name to the instance name

        /// `Ex.`
        @named
        @Injectable(as: Service)
        class A implements Service {}

        @injectable
        class MyRepo {
           final Service service;

           MyRepo(@Named.from(A) this.service)
        }

    5. @Named : define names (tags) for registered instance, for later mapping.

        /// `Ex.`
        @Named("impl1")
        @Injectable(as: Service)
        class ServiceImpl implements Service {}


    6. @singleton || @lazySingleton : An injectable class or module provider that provides a single instance.
        (singleton : at first time launch app for using later, cons : ex. make waiting splash screen more longer;
         lazySingleton : inject when using)

        /// `Ex.`
        @module
        abstract class RegisterModule {
          // You can register named preemptive types like follows
          @Named("BaseUrl")
          String get baseUrl => 'My base url';

          // url here will be injected
          @lazySingleton
          Dio dio(@Named('BaseUrl') String url) => Dio(BaseOptions(baseUrl: url));

          // same thing works for instances that's gotten asynchronous.
          // all you need to do is wrap your instance with a future and tell injectable how
          // to initialize it
          @preResolve // if you need to pre resolve the value
          Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
          // Also, make sure you await for your configure function before running the App.
        }

    7. @Singleton || @LazySingleton

        /// `Ex.`
        @Singleton(dispose: disposeDataSource)
        class DataSource {

          void dispose() {
            // logic to dispose instance
          }
        }
        /// dispose function signature must match Function(T instance)
        FutureOr disposeDataSource(DataSource instance){
           instance.dispose();
        }

        @Singleton(as: Service)
        class ServiceImpl implements Service {}

##### get_it

is a service locator that allows you to create interfaces and their implementations, and access
those implementations globally, anywhere in your app.

    /// `Ex.`
    abstract class RestService {}

    // Initialize it
    void main() {
      // Initialize get_it
      get_it.RestService restService = get_it.RestService();
    }

    // Use it
    void someFunction() {
      // Access the rest service
      restService.getData();
    }

### Melos Workspace Management

This project uses **Melos 7.x.x** with pub workspaces for monorepo management. Key features:

- **Workspace Configuration:** Defined in root `pubspec.yaml` with `workspace` key
- **Package Dependencies:** Uses `resolution: workspace` in package `pubspec.yaml` files
- **Code Generation:** Run `melos run gen` to generate files across all packages
- **Scripts:** Predefined scripts in root `pubspec.yaml` under `melos:` section

Common Melos commands:

```bash
# Bootstrap workspace (link packages, install dependencies)
melos bootstrap

# Run scripts across packages
melos run get        # Run pub get in all packages
melos run gen        # Run build_runner in packages that depend on it
melos run analyze    # Analyze all packages
melos run test       # Run tests across workspace

# Execute commands in specific packages
melos exec --scope=app_config -- "flutter analyze"
melos exec --depends-on="build_runner" -- "dart run build_runner build"
```

## Architecture & Module Structure

The project follows **Clean Architecture** with clear separation between:

- **libraries/**: Reusable packages (cc_sdk, cc_sdk_ui, features)
- **modules/**: App-specific modules (app_config, data, message, theme)
- **lib/**: Main application code

Each module follows the Clean Architecture layers:
- **domain/**: Business logic, use cases, repository interfaces
- **data/**: Data sources, repository implementations, entities  
- **presentation/**: UI components, pages, widgets

## Contributing

Before contributing, ensure you:

1. Run `melos bootstrap` to set up the workspace
2. Run `melos run gen` after adding new models or DI annotations
3. Run `melos run analyze` to check code quality
4. Run `melos run test` to ensure tests pass
5. Commit generated files (.g.dart) for app_config and data modules

For detailed contribution guidelines, see `docs/CONTRIBUTING.md`.
