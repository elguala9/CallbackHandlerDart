import '../interfaces/i_callback_handler.dart';
import '../types/callback_type.dart';
import '../utility/FastMap.dart';

/// Interface for handling callbacks
/// [T] is the type of callback function to be handled
class CallbackHandler<CallbackInputType, CallbackReturnType>
    implements ICallbackHandler<CallbackInputType, CallbackReturnType> {
  final FastMap<int, CallbackWithReturn<CallbackInputType, CallbackReturnType>>
      map;

  CallbackHandler()
      : map = FastMap<int,
            CallbackWithReturn<CallbackInputType, CallbackReturnType>>();

  /// Register a callback
  void register(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback) {
    map.set(callback.hashCode, callback);
  }

  /// Unregister a callback
  void unregister(
      CallbackWithReturn<CallbackInputType, CallbackReturnType> callback) {
    map.delete(callback.hashCode);
  }

  /// Invoke a registered callback
  void invoke(CallbackInputType input) {
    for (int i = 0; i < map.length; i++) map.getByIndex(i).call(input);
  }
}
