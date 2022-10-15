class Pair<T1, T2> {
  Pair(this.first, this.second);

  T1 first;
  T2 second;

  @override
  String toString() {
    return 'Pair($first, $second)';
  }

  @override
  bool operator ==(Object other) {
    if (other is Pair) {
      return first == other.first && second == other.second;
    }
    return false;
  }

  @override
  int get hashCode => '$first$second'.hashCode;
}
