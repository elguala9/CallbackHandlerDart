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
  /// Maps callback hashCodes to callback instances for O(1) lookup and removal.
  final FastMap<int, CallbackWithReturn<CallbackInputType, CallbackReturnType>>
      map;

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
    map.set(callback.hashCode, callback);
  }

  /// Unregister a callback
  @override
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback) {
    map.delete(callback.hashCode);
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
  }

  /// Make the handler callable as a function
  @override
  Map<int, CallbackReturnType> call(CallbackInputType input) {
    final results = <int, CallbackReturnType>{};
    for (int i = 0; i < map.length; i++) {
      final callback = map.getByIndex(i);
      results[callback.hashCode] = callback.call(input);
    }
    return results;
  }
}
