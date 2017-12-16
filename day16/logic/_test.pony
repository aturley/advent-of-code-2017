use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) ? =>
    let dl = DanceLine(5)
    ExecuteCommand(dl, "s1")?
    h.assert_array_eq[U8](dl.array(), "eabcd".array())
    ExecuteCommand(dl, "x3/4")?
    h.assert_array_eq[U8](dl.array(), "eabdc".array())
    ExecuteCommand(dl, "pe/b")?
    h.assert_array_eq[U8](dl.array(), "baedc".array())
