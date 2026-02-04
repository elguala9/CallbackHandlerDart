import 'package:callback_handler/callback_handler.dart';

void main() {
  basicExample();
  print('\n---\n');
  multipleCallbacksExample();
  print('\n---\n');
  eventBusExample();
}

/// Basic usage example
void basicExample() {
  print('Basic Example:');

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

  // Unregister when done
  handler.unregister(myCallback);
}

/// Example with multiple callbacks
void multipleCallbacksExample() {
  print('Multiple Callbacks Example:');

  final handler = CallbackHandler<int, int>();

  // Register multiple callbacks
  handler.register((x) {
    print('Callback 1: $x * 2 = ${x * 2}');
    return x * 2;
  });

  handler.register((x) {
    print('Callback 2: $x + 10 = ${x + 10}');
    return x + 10;
  });

  handler.register((x) {
    print('Callback 3: $x * $x = ${x * x}');
    return x * x;
  });

  // All callbacks are invoked
  handler.invoke(5);
}

/// Event bus implementation example
void eventBusExample() {
  print('Event Bus Example:');

  final bus = EventBus();

  // Subscribe to events
  bus.on('user:login', (user) {
    print('User logged in: ${user['name']}');
  });

  bus.on('user:login', (user) {
    print('Sending welcome email to: ${user['name']}');
  });

  bus.on('user:logout', (user) {
    print('User logged out: ${user['name']}');
  });

  // Emit events
  bus.emit('user:login', {'name': 'John Doe', 'id': 123});
  bus.emit('user:logout', {'name': 'John Doe', 'id': 123});
}

/// Simple event bus implementation using CallbackHandler
class EventBus {
  final _handlers = <String, CallbackHandler<dynamic, void>>{};

  void on(String event, void Function(dynamic) callback) {
    _handlers
        .putIfAbsent(
          event,
          () => CallbackHandler<dynamic, void>(),
        )
        .register(callback);
  }

  void emit(String event, dynamic data) {
    _handlers[event]?.invoke(data);
  }

  void off(String event, void Function(dynamic) callback) {
    _handlers[event]?.unregister(callback);
  }
}
