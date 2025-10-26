/// This library provides access to the AppConfig module's dependency injection system.
///
/// It exports the main service locator and initialization functions that should be used
/// throughout the application to access AppConfig module dependencies.
library app_config_di;

export 'di_app_config.dart'
    show
        // The main service locator instance
        appConfigLocator,

        // Configuration function (typically only used internally)
        configureDependencies,

        // Main initialization function (use this in main.dart)
        initAppConfig;
