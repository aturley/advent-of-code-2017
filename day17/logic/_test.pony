use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) =>
    let cb = CircularBuffer(3, 2017)
    let after_2017 = cb.find_value_after(2017)
    h.assert_eq[U64](638, after_2017)
