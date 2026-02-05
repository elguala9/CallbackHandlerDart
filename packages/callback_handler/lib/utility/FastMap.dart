class FastMap<K, V> {
  final List<V> _values = [];
  final Map<K, int> _keyToIndex = {};

  void set(K key, V value) {
    if (_keyToIndex.containsKey(key)) {
      _values[_keyToIndex[key]!] = value;
    } else {
      _keyToIndex[key] = _values.length;
      _values.add(value);
    }
  }

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

  V? get(K key) =>
      _keyToIndex.containsKey(key) ? _values[_keyToIndex[key]!] : null;
  V? operator [](dynamic key) => get(key as K);

  V getByIndex(int index) => _values[index];
  int get length => _values.length;

  void clear() {
    _values.clear();
    _keyToIndex.clear();
  }
}
