library mars_landing_test;

import '../lib/mars_landing.dart';
import 'package:unittest/unittest.dart';

main() {
  test("main test", () {
    var commands = """
5 3
1 1 E
RFRFRFRF

3 2 N
FRRFLLFFRRFLL

0 3 W
LLFFFLFLFL""";

    var result = landOnMars(commands);

    var expectedResult = """
1 1 E
3 3 N LOST
2 3 S
""";

    expect(result, equals(expectedResult));
  });
}