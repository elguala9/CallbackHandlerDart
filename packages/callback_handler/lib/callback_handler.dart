/// A high-performance callback management system for Dart applications.
///
/// This library provides type-safe callback handlers with O(1) registration
/// and deletion operations, making it ideal for event systems, observers,
/// and reactive programming patterns.
///
/// ## Features
///
/// - **Type-safe**: Full generic support for callback inputs and return types
/// - **High performance**: O(1) operations using optimized [FastMap]
/// - **Zero dependencies**: Lightweight with no external dependencies
/// - **Simple API**: Easy-to-use interface with register, unregister, and call
/// - **Flexible**: Support for void input/output types with `CallbackHandler<void, void>`
/// - **Multi-platform**: Works on all Dart platforms (VM, Web, Native)
///
/// ## Quick Start
///
/// ```dart
/// import 'package:callback_handler/callback_handler.dart';
///
/// // Create a handler for string inputs returning integers
/// final handler = CallbackHandler<String, int>();
///
/// // Register callbacks
/// handler.register((input) => input.length);
/// handler.register((input) => input.hashCode);
///
/// // Invoke all callbacks
/// final results = handler('Hello'); // Returns Map<int, int>
/// print(results); // {hashCode1: 5, hashCode2: 69609650}
/// ```
///
/// ## Advanced Usage
///
/// See the [example](https://github.com/elguala9/CallbackHandlerDart/tree/main/packages/callback_handler/example)
/// directory for complete examples including event bus patterns and state management.
library callback_handler;

export 'implementations/callback_handler.dart';
export 'interfaces/i_callback_handler.dart';
export 'types/callback_type.dart';
