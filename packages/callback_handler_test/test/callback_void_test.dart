import 'package:test/test.dart';
import 'package:callback_handler/callback_handler.dart';

void main() {
  group('CallbackVoid', () {
    late CallbackHandler<void, void> handler;

    setUp(() {
      handler = CallbackHandler<void, void>();
    });

    group('register', () {
      test('should register a void callback', () {
        void callback(void input) {}

        expect(() => handler.register(callback), returnsNormally);
      });

      test('should register multiple void callbacks', () {
        void callback1(void input) {}
        void callback2(void input) {}
        void callback3(void input) {}

        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);

        expect(handler.map.length, equals(3));
      });

      test('should register the same void callback instance only once', () {
        void callback(void input) {}

        handler.register(callback);
        handler.register(callback);

        // Same instance has same hashCode, so it should update not add
        expect(handler.map.length, equals(1));
      });

      test('should register different void callback instances', () {
        handler.register((void input) {});
        handler.register((void input) {});
        handler.register((void input) {});

        expect(handler.map.length, equals(3));
      });
    });

    group('unregister', () {
      test('should unregister a void callback', () {
        void callback(void input) {}

        handler.register(callback);
        expect(handler.map.length, equals(1));

        handler.unregister(callback);
        expect(handler.map.length, equals(0));
      });

      test('should handle unregister of non-existent void callback', () {
        void callback1(void input) {}
        void callback2(void input) {}

        handler.register(callback1);
        expect(handler.map.length, equals(1));

        handler.unregister(callback2);
        expect(handler.map.length, equals(1));
      });

      test('should unregister specific void callback among multiple', () {
        void callback1(void input) {}
        void callback2(void input) {}
        void callback3(void input) {}

        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);
        expect(handler.map.length, equals(3));

        handler.unregister(callback2);
        expect(handler.map.length, equals(2));

        // callback1 and callback3 should still be registered
        expect(handler.map.get(callback1.hashCode), equals(callback1));
        expect(handler.map.get(callback2.hashCode), isNull);
        expect(handler.map.get(callback3.hashCode), equals(callback3));
      });
    });

    group('invoke', () {
      test('should invoke a single void callback', () {
        int callCount = 0;
        void callback(void input) {
          callCount++;
        }
        handler.register(callback);

        final returnValues = handler.invoke(null);

        expect(callCount, equals(1));
        expect(returnValues, isA<Map<int, void>>());
        expect(returnValues.length, equals(1));
      });

      test('should invoke multiple void callbacks', () {
        int callCount = 0;

        void callback1(void input) {
          callCount++;
        }
        void callback2(void input) {
          callCount++;
        }
        void callback3(void input) {
          callCount++;
        }

        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);

        final returnValues = handler.invoke(null);

        expect(callCount, equals(3));
        expect(returnValues.length, equals(3));
      });

      test('should not invoke unregistered void callbacks', () {
        int callCount = 0;

        void callback1(void input) {
          callCount++;
        }
        void callback2(void input) {
          callCount++;
        }

        handler.register(callback1);
        handler.register(callback2);
        handler.unregister(callback1);

        final returnValues = handler.invoke(null);

        expect(callCount, equals(1));
        expect(returnValues.length, equals(1));
      });

      test('should handle invoke with no callbacks registered', () {
        expect(() => handler.invoke(null), returnsNormally);
        final returnValues = handler.invoke(null);
        expect(returnValues, isEmpty);
      });
    });

    group('call method', () {
      test('should call as function with void callbacks', () {
        int callCount = 0;
        void callback(void input) {
          callCount++;
        }
        handler.register(callback);

        final returnValues = handler(null);

        expect(callCount, equals(1));
        expect(returnValues.length, equals(1));
      });

      test('should call as function with multiple void callbacks', () {
        int callCount = 0;

        void callback1(void input) {
          callCount++;
        }
        void callback2(void input) {
          callCount++;
        }

        handler.register(callback1);
        handler.register(callback2);

        final returnValues = handler(null);

        expect(callCount, equals(2));
        expect(returnValues.length, equals(2));
      });
    });

    group('side effects', () {
      test('should execute void callbacks for side effects', () {
        final effects = <String>[];

        handler.register((void input) {
          effects.add('Effect1');
        });
        handler.register((void input) {
          effects.add('Effect2');
        });
        handler.register((void input) {
          effects.add('Effect3');
        });

        handler.invoke(null);

        expect(effects.length, equals(3));
        expect(effects, containsAll(['Effect1', 'Effect2', 'Effect3']));
      });

      test('should maintain state across multiple void callback invocations', () {
        int totalCalls = 0;

        handler.register((void input) {
          totalCalls++;
        });

        handler.invoke(null);
        handler.invoke(null);
        handler.invoke(null);

        expect(totalCalls, equals(3));
      });

      test('should handle void callbacks with shared mutable state', () {
        final results = <String>[];

        handler.register((void input) {
          results.add('Callback1');
        });
        handler.register((void input) {
          results.add('Callback2');
        });

        handler.invoke(null);
        expect(results, equals(['Callback1', 'Callback2']));

        results.clear();
        handler.invoke(null);
        expect(results, equals(['Callback1', 'Callback2']));
      });
    });

    group('edge cases', () {
      test('should handle rapid register and unregister of void callbacks', () {
        void callback(void input) {}

        for (int i = 0; i < 100; i++) {
          handler.register(callback);
          handler.unregister(callback);
        }

        expect(handler.map.length, equals(0));
      });

      test('should handle void callback that throws exception', () {
        handler.register((void input) {
          throw Exception('Callback error');
        });

        expect(() => handler.invoke(null), throwsException);
      });

      test('should invoke all void callbacks even if one has side effects', () {
        int callCount = 0;
        final effects = <String>[];

        handler.register((void input) {
          effects.add('Before');
          callCount++;
        });
        handler.register((void input) {
          effects.add('After');
          callCount++;
        });

        handler.invoke(null);

        expect(callCount, equals(2));
        expect(effects, equals(['Before', 'After']));
      });
    });

    group('integration', () {
      test('should handle full lifecycle of void callbacks', () {
        final events = <String>[];

        void callback1(void input) {
          events.add('CB1');
        }
        void callback2(void input) {
          events.add('CB2');
        }
        void callback3(void input) {
          events.add('CB3');
        }

        // Register callbacks
        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);

        // First invocation
        handler.invoke(null);
        expect(events.length, equals(3));

        // Unregister one
        handler.unregister(callback2);
        events.clear();

        // Second invocation
        handler.invoke(null);
        expect(events.length, equals(2));
        expect(events, containsAll(['CB1', 'CB3']));

        // Unregister all
        handler.unregister(callback1);
        handler.unregister(callback3);
        events.clear();

        // Third invocation (no callbacks)
        handler.invoke(null);
        expect(events.length, equals(0));
      });

      test('should work as event emitter pattern', () {
        final eventLog = <String>[];

        // Register multiple listeners
        handler.register((void _) {
          eventLog.add('Listener1 notified');
        });
        handler.register((void _) {
          eventLog.add('Listener2 notified');
        });

        // Emit event
        handler.invoke(null);
        expect(eventLog.length, equals(2));

        // Add more listeners
        handler.register((void _) {
          eventLog.add('Listener3 notified');
        });

        // Clear log and emit again
        eventLog.clear();
        handler.invoke(null);
        expect(eventLog.length, equals(3));
      });
    });
  });
}
