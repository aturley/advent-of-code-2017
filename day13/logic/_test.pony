use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)
    test(_TestExample2)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) =>
    let scanners = recover trn Map[U64, U64] end
    scanners(0) = 3
    scanners(1) = 2
    scanners(4) = 4
    scanners(6) = 4
    h.assert_eq[U64](CalculateSeverity(consume scanners)._1, 24)

class iso _TestExample2 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) =>
    let scanners = recover trn Map[U64, U64] end
    scanners(0) = 3
    scanners(1) = 2
    scanners(4) = 4
    scanners(6) = 4
    h.assert_eq[U64](CalculateSeverity(consume scanners, 10)._1, 0)
