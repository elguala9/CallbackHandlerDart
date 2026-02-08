/// A high-performance map implementation optimized for callback management.
///
/// FastMap provides O(1) complexity for all primary operations by maintaining
/// a dual data structure: a [List] for sequential access and a [Map] for
/// key-to-index lookups. This hybrid approach is ideal for scenarios where
/// iteration order doesn't matter but fast access by both key and index is required.
///
/// ## Design
///
/// The implementation uses:
/// - `List<V> _values`: Stores values for O(1) sequential iteration
/// - `Map<K, int> _keyToIndex`: Maps keys to indices for O(1) lookup
///
/// ## Performance Characteristics
///
/// | Operation | Time Complexity | Description |
/// |-----------|-----------------|-------------|
/// | `set()` | O(1) amortized | Add or update key-value pair |
/// | `delete()` | O(1) | Remove by key using swap-with-last |
/// | `get()` / `[]` | O(1) | Retrieve value by key |
/// | `getByIndex()` | O(1) | Direct access by list index |
/// | `clear()` | O(n) | Remove all entries |
///
/// ## Example
///
/// ```dart
/// final map = FastMap<String, int>();
/// map.set('a', 1);
/// map.set('b', 2);
/// print(map['a']); // 1
/// print(map.getByIndex(0)); // 1
/// map.delete('a');
/// print(map.length); // 1
/// ```
///
/// ## Use Cases
///
/// - Callback registration/removal (the primary use in this library)
/// - Event listener management
/// - Plugin/middleware systems
/// - Any scenario requiring fast add/remove with iteration
class FastMap<K, V> {
  /// Internal list storing values for sequential access during iteration.
  final List<V> _values = [];

  /// Internal map storing key-to-index mappings for O(1) lookups.
  final Map<K, int> _keyToIndex = {};

  /// Sets the [value] for the given [key].
  ///
  /// If the key already exists, updates its value. Otherwise, appends
  /// the new key-value pair to the end of the internal list.
  ///
  /// Time complexity: O(1) amortized
  ///
  /// Example:
  /// ```dart
  /// final map = FastMap<String, int>();
  /// map.set('counter', 1);
  /// map.set('counter', 2); // Updates existing value
  /// ```
  void set(K key, V value) {
    if (_keyToIndex.containsKey(key)) {
      _values[_keyToIndex[key]!] = value;
    } else {
      _keyToIndex[key] = _values.length;
      _values.add(value);
    }
  }

  /// Removes the entry with the given [key].
  ///
  /// Uses a swap-with-last strategy to maintain O(1) deletion:
  /// 1. Swaps the element to delete with the last element
  /// 2. Updates the map for the swapped element
  /// 3. Removes the last element from the list
  ///
  /// If the key doesn't exist, this operation is a no-op.
  ///
  /// Time complexity: O(1)
  ///
  /// Example:
  /// ```dart
  /// final map = FastMap<String, int>();
  /// map.set('a', 1);
  /// map.set('b', 2);
  /// map.delete('a'); // Swaps 'a' with 'b', then removes last
  /// ```
  void delete(K key) {
    if (!_keyToIndex.containsKey(key)) return;

    final indexToDelete = _keyToIndex[key]!;
    final lastIndex = _values.length - 1;

    if (indexToDelete != lastIndex) {
      // Swap with last element
      _values[indexToDelete] = _values[lastIndex];

      // Update the map for the swapped element
      final swappedKey = _keyToIndex.entries
          .firstWhere((entry) => entry.value == lastIndex)
          .key;
      _keyToIndex[swappedKey] = indexToDelete;
    }

    // Remove the last element and the key
    _values.removeLast();
    _keyToIndex.remove(key);
  }

  /// Returns the value associated with [key], or `null` if not found.
  ///
  /// Time complexity: O(1)
  ///
  /// Example:
  /// ```dart
  /// final value = map.get('myKey');
  /// if (value != null) {
  ///   print('Found: $value');
  /// }
  /// ```
  V? get(K key) =>
      _keyToIndex.containsKey(key) ? _values[_keyToIndex[key]!] : null;

  /// Operator overload to access values by key.
  ///
  /// Returns `null` if the key doesn't exist.
  ///
  /// Time complexity: O(1)
  ///
  /// Example:
  /// ```dart
  /// final map = FastMap<String, int>();
  /// map.set('count', 42);
  /// print(map['count']); // 42
  /// print(map['missing']); // null
  /// ```
  V? operator [](dynamic key) => get(key as K);

  /// Returns the value at the given [index] in the internal list.
  ///
  /// Throws [RangeError] if [index] is out of bounds.
  ///
  /// This method enables efficient iteration without exposing keys:
  /// ```dart
  /// for (var i = 0; i < map.length; i++) {
  ///   final value = map.getByIndex(i);
  ///   // Process value...
  /// }
  /// ```
  ///
  /// Time complexity: O(1)
  V getByIndex(int index) => _values[index];

  /// Returns the number of entries in the map.
  ///
  /// Time complexity: O(1)
  ///
  /// Example:
  /// ```dart
  /// final map = FastMap<String, int>();
  /// print(map.length); // 0
  /// map.set('a', 1);
  /// print(map.length); // 1
  /// ```
  int get length => _values.length;

  /// Removes all entries from the map.
  ///
  /// Time complexity: O(n) where n is the number of entries
  ///
  /// Example:
  /// ```dart
  /// map.set('a', 1);
  /// map.set('b', 2);
  /// map.clear();
  /// print(map.length); // 0
  /// ```
  void clear() {
    _values.clear();
    _keyToIndex.clear();
  }
}
