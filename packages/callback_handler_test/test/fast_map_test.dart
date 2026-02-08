import 'package:test/test.dart';
import 'package:callback_handler/utility/fast_map.dart';

void main() {
  group('FastMap', () {
    late FastMap<String, int> map;

    setUp(() {
      map = FastMap<String, int>();
    });

    group('set and get', () {
      test('should set and get a value', () {
        map.set('key1', 10);
        expect(map.get('key1'), equals(10));
        expect(map['key1'], equals(10));
      });

      test('should return null for non-existent key', () {
        expect(map.get('nonexistent'), isNull);
        expect(map['nonexistent'], isNull);
      });

      test('should update existing value', () {
        map.set('key1', 10);
        map.set('key1', 20);
        expect(map.get('key1'), equals(20));
      });

      test('should handle multiple keys', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        expect(map.get('key1'), equals(10));
        expect(map.get('key2'), equals(20));
        expect(map.get('key3'), equals(30));
        expect(map.length, equals(3));
      });
    });

    group('delete', () {
      test('should delete existing key', () {
        map.set('key1', 10);
        map.delete('key1');
        expect(map.get('key1'), isNull);
        expect(map.length, equals(0));
      });

      test('should handle delete of non-existent key', () {
        map.set('key1', 10);
        map.delete('nonexistent');
        expect(map.get('key1'), equals(10));
        expect(map.length, equals(1));
      });

      test('should delete from middle and maintain other values', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        map.delete('key2');

        expect(map.get('key1'), equals(10));
        expect(map.get('key2'), isNull);
        expect(map.get('key3'), equals(30));
        expect(map.length, equals(2));
      });

      test('should delete first element correctly', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        map.delete('key1');

        expect(map.get('key1'), isNull);
        expect(map.get('key2'), equals(20));
        expect(map.get('key3'), equals(30));
        expect(map.length, equals(2));
      });

      test('should delete last element correctly', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        map.delete('key3');

        expect(map.get('key1'), equals(10));
        expect(map.get('key2'), equals(20));
        expect(map.get('key3'), isNull);
        expect(map.length, equals(2));
      });

      test('should handle multiple deletes', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);
        map.set('key4', 40);

        map.delete('key2');
        map.delete('key3');

        expect(map.get('key1'), equals(10));
        expect(map.get('key2'), isNull);
        expect(map.get('key3'), isNull);
        expect(map.get('key4'), equals(40));
        expect(map.length, equals(2));
      });

      test('should handle delete and re-add same key', () {
        map.set('key1', 10);
        map.delete('key1');
        map.set('key1', 20);

        expect(map.get('key1'), equals(20));
        expect(map.length, equals(1));
      });
    });

    group('getByIndex', () {
      test('should get value by index', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        expect(map.getByIndex(0), equals(10));
        expect(map.getByIndex(1), equals(20));
        expect(map.getByIndex(2), equals(30));
      });

      test('should maintain correct indices after delete', () {
        map.set('key1', 10);
        map.set('key2', 20);
        map.set('key3', 30);

        map.delete('key2');

        // After delete, key3 should be swapped to index 1
        expect(map.length, equals(2));
        expect(map.getByIndex(0), equals(10));
        expect(map.getByIndex(1), equals(30));
      });
    });

    group('length', () {
      test('should return 0 for empty map', () {
        expect(map.length, equals(0));
      });

      test('should return correct length after operations', () {
        expect(map.length, equals(0));

        map.set('key1', 10);
        expect(map.length, equals(1));

        map.set('key2', 20);
        expect(map.length, equals(2));

        map.delete('key1');
        expect(map.length, equals(1));

        map.delete('key2');
        expect(map.length, equals(0));
      });
    });

    group('edge cases', () {
      test('should handle empty map operations', () {
        map.delete('nonexistent');
        expect(map.length, equals(0));
      });

      test('should handle complex types as values', () {
        final complexMap = FastMap<String, Map<String, dynamic>>();
        final value1 = {'name': 'test1', 'count': 1};
        final value2 = {'name': 'test2', 'count': 2};

        complexMap.set('key1', value1);
        complexMap.set('key2', value2);

        expect(complexMap.get('key1'), equals(value1));
        expect(complexMap.get('key2'), equals(value2));
      });

      test('should handle integer keys', () {
        final intMap = FastMap<int, String>();
        intMap.set(1, 'one');
        intMap.set(2, 'two');
        intMap.set(3, 'three');

        expect(intMap.get(1), equals('one'));
        expect(intMap.get(2), equals('two'));
        expect(intMap.get(3), equals('three'));

        intMap.delete(2);
        expect(intMap.get(2), isNull);
        expect(intMap.length, equals(2));
      });
    });
  });
}
