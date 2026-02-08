import '../types/callback_type.dart';

/// Interface defining the contract for callback handlers.
///
/// Implement this interface to create custom callback handling behavior.
///
/// Type parameters:
/// * [CallbackInputType] - The type of input accepted by callbacks
/// * [CallbackReturnType] - The type of value returned by callbacks
abstract interface class ICallbackHandler<CallbackInputType,
    CallbackReturnType> {
  /// Registers a new callback function.
  ///
  /// The [callback] will be stored and invoked when [call] is called.
  /// The same callback instance can only be registered once (identified by [hashCode]).
  ///
  /// Example:
  /// ```dart
  /// final handler = CallbackHandler<int, String>();
  /// handler.register((n) => 'Number: $n');
  /// ```
  void register(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Removes a previously registered callback.
  ///
  /// After unregistering, the [callback] will no longer be invoked.
  /// If the callback was not registered, this operation is a no-op.
  ///
  /// Example:
  /// ```dart
  /// final callback = (int n) => n * 2;
  /// handler.register(callback);
  /// handler.unregister(callback); // Removes the callback
  /// ```
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Invokes all registered callbacks with the given [input].
  ///
  /// All registered callbacks will receive the same [input] value.
  /// Returns a map with callback hashCode as key and return value as value.
  ///
  /// **Deprecated**: Use [call] instead. This method will be removed in version 1.0.0.
  @Deprecated(
      'Use call() instead. This method will be removed in version 1.0.0.')
  Map<int, CallbackReturnType> invoke(CallbackInputType input);

  /// Call all registered callbacks with the given [input].
  ///
  /// All registered callbacks will receive the same [input] value.
  /// Returns a map with callback hashCode as key and return value as value.
  Map<int, CallbackReturnType> call(CallbackInputType input);

  /// Removes all registered callbacks from the handler.
  ///
  /// After calling this method, the handler contains no callbacks and
  /// [call] will return an empty map.
  ///
  /// Example:
  /// ```dart
  /// handler.register((n) => n * 2);
  /// handler.register((n) => n * 3);
  /// handler.clear();
  /// print(handler(5)); // {} (empty map)
  /// ```
  void clear();
}
