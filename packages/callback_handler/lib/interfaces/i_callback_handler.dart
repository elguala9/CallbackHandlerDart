import '../types/callback_type.dart';

/// Interface for handling callbacks
/// [T] is the type of callback function to be handled
abstract interface class ICallbackHandler<CallbackInputType,
    CallbackReturnType> {
  /// Register a callback
  void register(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Unregister a callback
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback);

  /// Invoke a registered callback
  void invoke(CallbackInputType input);
}
