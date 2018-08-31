use "collections"
use "debug"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestCarrier)
    test(_TestCarrierEvolved)

class iso _TestCarrier is UnitTest
  fun name(): String => "Carrier"

  fun apply(h: TestHelper) ? =>
    let grid = GridFromStrings(["..#"; "#.."; "..."])?
    let c = Carrier(((grid.size() / 2).isize(), (grid.size() / 2).isize()))

    for i in Range(1, 10001) do
      c.burst(grid)?
      match i
      | 7 =>
        h.assert_eq[USize](5, c.infections())
      | 70 =>
        h.assert_eq[USize](41, c.infections())
      | 10000 =>
        h.assert_eq[USize](5587, c.infections())
      end
    end

class iso _TestCarrierEvolved is UnitTest
  fun name(): String => "CarrierEvolved"

  fun apply(h: TestHelper) ? =>
    let grid = GridFromStrings(["..#"; "#.."; "..."])?
    let c = Carrier(((grid.size() / 2).isize(), (grid.size() / 2).isize()))

    for i in Range(1, 10000001) do
      c.burst(grid, true)?
      match i
      | 100 =>
        h.assert_eq[USize](26, c.infections())
      | 10000000 =>
        h.assert_eq[USize](2511944, c.infections())
      end
    end
