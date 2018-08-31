use "debug"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestPatternBook)
    test(_TestGridFromString)
    test(_TestGridToSquares)
    test(_TestGridTransform)

class iso _TestPatternBook is UnitTest
  fun name(): String => "PatternBook"

  fun apply(h: TestHelper) ? =>
    let pb = PatternBook
    pb.add_pattern("../.#", "A")

    h.assert_eq[String]("A", pb.lookup("../.#")?)
    h.assert_eq[String]("A", pb.lookup("../#.")?)
    h.assert_eq[String]("A", pb.lookup(".#/..")?)
    h.assert_eq[String]("A", pb.lookup("#./..")?)

    pb.add_pattern(".../.../.##", "B")

    h.assert_eq[String]("B", pb.lookup(".../.../##.")?)

class iso _TestGridFromString is UnitTest
  fun name(): String => "GridFromString"

  fun apply(h: TestHelper) ? =>
    let grid0 = GridFromStrings([[".#./..#/###"]])?
    h.assert_eq[String](".#.\n..#\n###", grid0.string())

    let grid1 = GridFromStrings([[".#/.."; "../#."]; ["##/.."; "#./.."]])?
    h.assert_eq[String](".#..\n..#.\n###.\n....", grid1.string())

class iso _TestGridToSquares is UnitTest
  fun name(): String => "GridFromString"

  fun apply(h: TestHelper) ? =>
    let grid0 = GridFromStrings([[".#./..#/###"]])?
    h.assert_eq[USize](1, grid0.squares()?.size())

    let grid1 = GridFromStrings([[".#/.."; "../#."]; ["##/.."; "#./.."]])?
    h.assert_eq[USize](2, grid1.squares()?.size())
    h.assert_eq[USize](2, grid1.squares()?(0)?.size())
    h.assert_eq[USize](2, grid1.squares()?(1)?.size())
    h.assert_eq[USize](5, grid1.squares()?(1)?(0)?.size())

class iso _TestGridTransform is UnitTest
  fun name(): String => "GridTransform"

  fun apply(h: TestHelper) ? =>
    let pb = PatternBook
    pb.add_pattern("../.#", "##./#../...")
    pb.add_pattern(".#./..#/###", "#..#/..../..../#..#")

    let grid0 = GridFromStrings([[".#./..#/###"]])?

    h.assert_eq[USize](12, grid0.transform(pb)?.transform(pb)?.count_on())
