use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1("ne,ne,ne", 3))
    test(_TestExample1("ne,ne,sw,sw", 0))
    test(_TestExample1("ne,ne,s,s", 2))
    test(_TestExample1("se,sw,se,sw,sw", 3))

class iso _TestExample1 is UnitTest
  let _script: String
  let _expected_distance: I64

  new iso create(script: String, expected_distance: I64) =>
    _script = script
    _expected_distance = expected_distance

  fun name(): String => _script

  fun apply(h: TestHelper) ? =>
    let ht: HexTraveler ref = HexTraveler

    RunTravelerScript(ht, _script)?

    h.assert_eq[I64](ht.distance_from_origin(), _expected_distance)
