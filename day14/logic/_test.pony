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

  fun apply(h: TestHelper) ? =>
    let hashes = CalculateHashes("flqrgnkx")?
    h.assert_eq[U64](HashPopulations(hashes), 8108)

class iso _TestExample2 is UnitTest
  fun name(): String => "Example 2"

  fun apply(h: TestHelper) ? =>
    let hashes = CalculateHashes("flqrgnkx")?
    h.assert_eq[U64](CountRegions(hashes), 1242)
