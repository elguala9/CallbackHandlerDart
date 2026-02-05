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
  /// The [callback] will be stored and invoked when [invoke] is called.
  void register(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Removes a previously registered callback.
  ///
  /// After unregistering, the [callback] will no longer be invoked.
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Invokes all registered callbacks with the given [input].
  ///
  /// All registered callbacks will receive the same [input] value.
  void invoke(CallbackInputType input);

  /// Clear the object
  void clear();
}
