import 'package:test/test.dart';
import 'package:callback_handler/callback_handler.dart';

void main() {
  group('CallbackHandler', () {
    late CallbackHandler<String, String> handler;

    setUp(() {
      handler = CallbackHandler<String, String>();
    });

    group('register', () {
      test('should register a callback', () {
        String callback(String input) => 'Result: $input';

        expect(() => handler.register(callback), returnsNormally);
      });

      test('should register multiple callbacks', () {
        String callback1(String input) => 'Callback1: $input';
        String callback2(String input) => 'Callback2: $input';
        String callback3(String input) => 'Callback3: $input';

        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);

        expect(handler.map.length, equals(3));
      });

      test('should register the same callback instance only once', () {
        String callback(String input) => 'Result: $input';

        handler.register(callback);
        handler.register(callback);

        // Same instance has same hashCode, so it should update not add
        expect(handler.map.length, equals(1));
      });

      test('should register different callback instances', () {
        // Different instances, even with same implementation
        handler.register((input) => 'Result1: $input');
        handler.register((input) => 'Result2: $input');
        handler.register((input) => 'Result3: $input');

        expect(handler.map.length, equals(3));
      });
    });

    group('unregister', () {
      test('should unregister a callback', () {
        String callback(String input) => 'Result: $input';

        handler.register(callback);
        expect(handler.map.length, equals(1));

        handler.unregister(callback);
        expect(handler.map.length, equals(0));
      });

      test('should handle unregister of non-existent callback', () {
        String callback1(String input) => 'Result1: $input';
        String callback2(String input) => 'Result2: $input';

        handler.register(callback1);
        expect(handler.map.length, equals(1));

        handler.unregister(callback2);
        expect(handler.map.length, equals(1));
      });

      test('should unregister specific callback among multiple', () {
        String callback1(String input) => 'Result1: $input';
        String callback2(String input) => 'Result2: $input';
        String callback3(String input) => 'Result3: $input';

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
      test('should invoke a single callback', () {
        final results = <String>[];
        handler.register((input) {
          results.add('Called with: $input');
          return 'Result';
        });

        handler.invoke('test');
        expect(results, equals(['Called with: test']));
      });

      test('should invoke multiple callbacks', () {
        final results = <String>[];

        handler.register((input) {
          results.add('Callback1: $input');
          return 'Result1';
        });
        handler.register((input) {
          results.add('Callback2: $input');
          return 'Result2';
        });
        handler.register((input) {
          results.add('Callback3: $input');
          return 'Result3';
        });

        handler.invoke('test');

        // All callbacks should be invoked
        expect(results.length, equals(3));
        expect(results, contains('Callback1: test'));
        expect(results, contains('Callback2: test'));
        expect(results, contains('Callback3: test'));
      });

      test('should not invoke unregistered callbacks', () {
        final results = <String>[];

        String callback1(String input) {
          results.add('Callback1: $input');
          return 'Result1';
        }
        String callback2(String input) {
          results.add('Callback2: $input');
          return 'Result2';
        }

        handler.register(callback1);
        handler.register(callback2);
        handler.unregister(callback1);

        handler.invoke('test');

        expect(results, equals(['Callback2: test']));
      });

      test('should handle invoke with no callbacks registered', () {
        expect(() => handler.invoke('test'), returnsNormally);
      });

      test('should pass correct input to callbacks', () {
        String? receivedInput;
        handler.register((input) {
          receivedInput = input;
          return 'Result';
        });

        handler.invoke('test input');
        expect(receivedInput, equals('test input'));
      });
    });

    group('type safety', () {
      test('should handle int input and output', () {
        final intHandler = CallbackHandler<int, int>();
        final results = <int>[];

        intHandler.register((input) {
          results.add(input * 2);
          return input * 2;
        });

        intHandler.invoke(5);
        expect(results, equals([10]));
      });

      test('should handle complex types', () {
        final complexHandler = CallbackHandler<Map<String, dynamic>, List<String>>();
        final results = <List<String>>[];

        complexHandler.register((input) {
          final result = [input['name'] as String, input['value'].toString()];
          results.add(result);
          return result;
        });

        complexHandler.invoke({'name': 'test', 'value': 42});
        expect(results, equals([['test', '42']]));
      });
    });

    group('edge cases', () {
      test('should handle rapid register and unregister', () {
        String callback(String input) => 'Result: $input';

        for (int i = 0; i < 100; i++) {
          handler.register(callback);
          handler.unregister(callback);
        }

        expect(handler.map.length, equals(0));
      });

      test('should handle callback that throws exception', () {
        handler.register((input) {
          throw Exception('Callback error');
        });

        expect(() => handler.invoke('test'), throwsException);
      });

      test('should maintain state across multiple invocations', () {
        int callCount = 0;
        handler.register((input) {
          callCount++;
          return 'Result $callCount';
        });

        handler.invoke('test1');
        handler.invoke('test2');
        handler.invoke('test3');

        expect(callCount, equals(3));
      });

      test('should handle callbacks with side effects', () {
        final sideEffects = <String>[];

        handler.register((input) {
          sideEffects.add('Effect1');
          return 'Result1';
        });
        handler.register((input) {
          sideEffects.add('Effect2');
          return 'Result2';
        });

        handler.invoke('test');

        expect(sideEffects.length, equals(2));
        expect(sideEffects, containsAll(['Effect1', 'Effect2']));
      });
    });

    group('integration', () {
      test('should handle full lifecycle', () {
        final events = <String>[];

        String callback1(String input) {
          events.add('CB1: $input');
          return 'R1';
        }
        String callback2(String input) {
          events.add('CB2: $input');
          return 'R2';
        }
        String callback3(String input) {
          events.add('CB3: $input');
          return 'R3';
        }

        // Register callbacks
        handler.register(callback1);
        handler.register(callback2);
        handler.register(callback3);

        // First invocation
        handler.invoke('first');
        expect(events.length, equals(3));

        // Unregister one
        handler.unregister(callback2);
        events.clear();

        // Second invocation
        handler.invoke('second');
        expect(events.length, equals(2));
        expect(events, containsAll(['CB1: second', 'CB3: second']));

        // Unregister all
        handler.unregister(callback1);
        handler.unregister(callback3);
        events.clear();

        // Third invocation (no callbacks)
        handler.invoke('third');
        expect(events.length, equals(0));
      });
    });
  });
}
