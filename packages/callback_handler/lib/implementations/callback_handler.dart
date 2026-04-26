import '../interfaces/i_callback_handler.dart';
import '../types/callback_type.dart';
import '../utility/fast_map.dart';

/// Implementation of [ICallbackHandler] for managing callbacks with generic types.
///
/// This class provides a high-performance callback management system using
/// [FastMap] for O(1) registration and removal operations.
///
/// Type parameters:
/// * [CallbackInputType] - The input parameter type accepted by callbacks
/// * [CallbackReturnType] - The return type produced by callbacks
///
/// Example:
/// ```dart
/// final handler = CallbackHandler<String, int>();
/// handler.register((input) => input.length);
/// final results = handler.call('Hello');
/// print(results); // {callback_hashCode: 5}
/// ```
///
/// Performance characteristics:
/// - Register: O(1) amortized
/// - Unregister: O(1)
/// - Invoke/Call: O(n) where n is the number of registered callbacks
/// - Clear: O(n)
class CallbackHandler<CallbackInputType, CallbackReturnType>
    implements ICallbackHandler<CallbackInputType, CallbackReturnType> {
  /// Internal storage for registered callbacks.
  ///
  /// Maps unique IDs to callback instances for O(1) lookup and removal.
  final FastMap<int, CallbackWithReturn<CallbackInputType, CallbackReturnType>>
      map;

  /// List of keys in insertion order to support iteration
  final List<int> _keys = [];

  /// Counter for generating unique IDs for each registration
  int _nextId = 0;

  /// Creates a new [CallbackHandler] instance.
  ///
  /// Initializes an empty callback storage with O(1) operations.
  CallbackHandler()
      : map = FastMap<int,
            CallbackWithReturn<CallbackInputType, CallbackReturnType>>();

  /// Register a callback
  @override
  void register(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback) {
    final id = _nextId++;
    map.set(id, callback);
    _keys.add(id);
  }

  /// Unregister a callback
  @override
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback) {
    // Find and remove the first occurrence of this callback
    for (int i = 0; i < _keys.length; i++) {
      final id = _keys[i];
      if (map.get(id) == callback) {
        map.delete(id);
        _keys.removeAt(i);
        return;
      }
    }
  }

  /// Invoke all registered callbacks with the given input (deprecated).
  ///
  /// This method is deprecated. Use [call] instead for cleaner syntax.
  ///
  /// **Deprecated**: This method will be removed in version 1.0.0.
  @Deprecated(
      'Use call() instead. This method will be removed in version 1.0.0.')
  @override
  Map<int, CallbackReturnType> invoke(CallbackInputType input) {
    return call(input);
  }

  /// Clear all registered callbacks
  @override
  void clear() {
    map.clear();
    _keys.clear();
  }

  /// Make the handler callable as a function
  @override
  Map<int, CallbackReturnType> call(CallbackInputType input) {
    final results = <int, CallbackReturnType>{};
    for (final id in _keys) {
      final callback = map.get(id)!;
      results[id] = callback.call(input);
    }
    return results;
  }
}
