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
    h.assert_eq[String](dl.string(), "eabcd")
    ExecuteCommand(dl, "x3/4")?
    h.assert_eq[String](dl.string(), "eabdc")
    ExecuteCommand(dl, "pe/b")?
    h.assert_eq[String](dl.string(), "baedc")
