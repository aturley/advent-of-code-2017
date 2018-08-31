use "debug"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestComponents)
    test(_TestComponentCombinations)
    test(_TestExample1)

class iso _TestComponents is UnitTest
  fun name(): String => "Components"

  fun apply(h: TestHelper) ? =>
    let components = recover val ComponentsFromString("""
13/5
3/2""")? end
    h.assert_eq[USize](2, components.size())

class iso _TestComponentCombinations is UnitTest
  fun name(): String => "ComponentCombinations"

  fun apply(h: TestHelper) ? =>
    let components = recover val ComponentsFromString("""
0/13
13/5
13/2""")? end
    let cmap = ComponentsMapFromComponents(components)?

    h.assert_eq[USize](3, cmap(13)?.size())
    h.assert_eq[USize](1, cmap(5)?.size())
    h.assert_eq[USize](1, cmap(2)?.size())

    let bridges = BuildBridges(components, cmap)?

    let high_score = ScoreBridges(bridges)

    h.assert_eq[USize](31, high_score)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example1"

  fun apply(h: TestHelper) ? =>
    let components = recover val ComponentsFromString("""
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10""")? end
    let cmap = ComponentsMapFromComponents(components)?

    let bridges = BuildBridges(components, cmap)?

    let high_score = ScoreBridges(bridges)

    h.assert_eq[USize](31, high_score)
