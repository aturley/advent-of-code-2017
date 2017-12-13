use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) ? =>
    let connections: ProgramConnections ref = ProgramConnections

    connections.>add_connection("0", "2")?
      .>add_connection("1", "1")?
      .>add_connection("2", "0")?
      .>add_connection("2", "3")?
      .>add_connection("2", "4")?
      .>add_connection("3", "2")?
      .>add_connection("3", "4")?
      .>add_connection("4", "2")?
      .>add_connection("4", "3")?
      .>add_connection("4", "6")?
      .>add_connection("5", "6")?
      .>add_connection("6", "4")?
      .>add_connection("6", "5")?

    h.assert_eq[USize](FindGroup("0", connections).size(), 6)
