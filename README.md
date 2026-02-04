# CallbackHandler

A Dart monorepo for efficient callback management with a high-performance FastMap implementation.

## Packages

### callback_handler
Core library providing callback registration, unregistration, and invocation with generic type support.

**Features:**
- Type-safe callback handling with generics
- Fast O(1) registration and deletion using FastMap
- Support for multiple callbacks with automatic invocation
- Clean interface-based design

### callback_handler_test
Comprehensive test suite for the callback_handler package.

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  callback_handler:
    path: packages/callback_handler
```

### Usage

```dart
import 'package:callback_handler/callback_handler.dart';

void main() {
  // Create a handler with String input and String return type
  final handler = CallbackHandler<String, String>();

  // Register callbacks
  handler.register((input) {
    print('Callback 1: $input');
    return 'Result 1';
  });

  handler.register((input) {
    print('Callback 2: $input');
    return 'Result 2';
  });

  // Invoke all registered callbacks
  handler.invoke('Hello World');

  // Unregister a callback
  handler.unregister(callback);
}
```

## Development

This project uses [Melos](https://melos.invertase.dev/) for monorepo management.

### Setup

```bash
# Install Melos
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap
```

### Running Tests

```bash
# Run all tests
melos run test

# Run tests for a specific package
cd packages/callback_handler_test
dart test
```

### Package Structure

```
CallbackHandlerDart/
├── packages/
│   ├── callback_handler/       # Core library
│   │   ├── lib/
│   │   │   ├── implementations/
│   │   │   ├── interfaces/
│   │   │   ├── types/
│   │   │   └── utility/
│   │   └── pubspec.yaml
│   └── callback_handler_test/  # Test package
│       ├── lib/
│       ├── test/
│       └── pubspec.yaml
├── melos.yaml
└── pubspec.yaml
```

## License

See LICENSE file for details.
