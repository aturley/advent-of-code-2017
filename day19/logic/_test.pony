use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestMap)

class iso _TestMap is UnitTest
  fun name(): String => "MapFromString"

  fun apply(h: TestHelper) ? =>
    let map_string =
      "     |\n" +
      "     |  +--+\n" +
      "     A  |  C\n" +
      " F---|----E|--+\n" +
      "     |  |  |  D\n" +
      "     +B-+  +--+\n"


    let map = MapFromString(map_string)?
    let trace = map.trace()?

    h.assert_eq[ISize](3, trace._1._1)
    h.assert_eq[ISize](1, trace._1._2)
    h.assert_eq[String]("ABCDEF", "".join(trace._2.values()))
    h.assert_eq[USize](38, trace._3)
