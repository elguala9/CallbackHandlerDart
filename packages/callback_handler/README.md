# callback_handler

[![pub package](https://img.shields.io/pub/v/callback_handler.svg)](https://pub.dev/packages/callback_handler)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A high-performance Dart package for managing callbacks with type-safe generics and O(1) operations.

## Features

- **Type-Safe**: Full generic type support for inputs and return values
- **High Performance**: O(1) registration and deletion using optimized FastMap
- **Multiple Callbacks**: Register and invoke multiple callbacks efficiently
- **Clean Architecture**: Interface-based design for easy testing and extension
- **Zero Dependencies**: Lightweight with no external dependencies

## Installation

Add this to your package's `pubspec.yaml`:

```yaml
dependencies:
  callback_handler: ^0.0.1
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Example

```dart
import 'package:callback_handler/callback_handler.dart';

void main() {
  // Create a handler with String input and String return type
  final handler = CallbackHandler<String, String>();

  // Register a callback
  String myCallback(String input) {
    print('Received: $input');
    return 'Processed: $input';
  }

  handler.register(myCallback);

  // Invoke all registered callbacks
  handler.invoke('Hello World');
  // Output: Received: Hello World

  // Unregister when done
  handler.unregister(myCallback);
}
```

### Multiple Callbacks

```dart
final handler = CallbackHandler<int, int>();

// Register multiple callbacks
handler.register((x) => x * 2);
handler.register((x) => x + 10);
handler.register((x) => x * x);

// All callbacks are invoked
handler.invoke(5);
```

### Type Safety with Generics

```dart
// Handler for complex types
final dataHandler = CallbackHandler<Map<String, dynamic>, List<String>>();

dataHandler.register((data) {
  return [data['name'] as String, data['value'].toString()];
});

final result = dataHandler.invoke({'name': 'test', 'value': 42});
```

### Event System Example

```dart
class EventBus {
  final _handlers = <String, CallbackHandler<dynamic, void>>{};

  void on(String event, void Function(dynamic) callback) {
    _handlers.putIfAbsent(
      event,
      () => CallbackHandler<dynamic, void>(),
    ).register(callback);
  }

  void emit(String event, dynamic data) {
    _handlers[event]?.invoke(data);
  }

  void off(String event, void Function(dynamic) callback) {
    _handlers[event]?.unregister(callback);
  }
}

void main() {
  final bus = EventBus();

  // Subscribe to events
  bus.on('user:login', (user) => print('User logged in: $user'));
  bus.on('user:login', (user) => print('Send welcome email to: $user'));

  // Emit event
  bus.emit('user:login', {'name': 'John', 'id': 123});
}
```

## API Reference

### CallbackHandler<InputType, ReturnType>

Main class for managing callbacks.

#### Methods

- `void register(CallbackWithReturn<InputType, ReturnType> callback)` - Register a new callback
- `void unregister(CallbackWithReturn<InputType, ReturnType> callback)` - Remove a registered callback
- `void invoke(InputType input)` - Invoke all registered callbacks with the given input

### ICallbackHandler<InputType, ReturnType>

Interface defining the contract for callback handlers. Implement this for custom behavior.

### CallbackWithReturn<I, R>

Type definition for callbacks: `R Function(I)`

## Performance

The package uses an optimized FastMap implementation that provides:
- O(1) callback registration
- O(1) callback deletion
- O(n) invocation (where n is the number of registered callbacks)

Ideal for high-frequency event systems and real-time applications.

## Testing

The package includes comprehensive tests covering:
- Registration and unregistration
- Multiple callback scenarios
- Type safety
- Edge cases and error handling

Run tests:
```bash
dart test
```

## Additional Information

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Issues

If you encounter any issues, please file them on the [issue tracker](https://github.com/yourusername/callback_handler/issues).

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
