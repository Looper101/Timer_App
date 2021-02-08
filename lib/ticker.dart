class Ticker {
  Stream<int> tick({int tick}) {
    return Stream.periodic(Duration(seconds: 1), (x) {
      print('x: $x');
      return tick - x - 1;
    }).take(tick);
  }
}
