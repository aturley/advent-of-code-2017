use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) ? =>
    let start = [as U64: 0; 1; 2; 3; 4]
    let lengths = [as USize: 3; 4; 1; 5]
    let expected = [as U64: 3; 4; 2; 1; 0]
    GenerateHash(start, lengths, 0, 9)?
    h.assert_array_eq[U64](start, expected)
