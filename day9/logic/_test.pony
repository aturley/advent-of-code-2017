use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
    new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1("{}", 1))
    test(_TestExample1("{{{}}}", 6))
    test(_TestExample1("{{},{}}", 5))
    test(_TestExample1("{{{},{},{{}}}}", 16))
    test(_TestExample1("{<a>,<a>,<a>,<a>}", 1))
    test(_TestExample1("{{<ab>},{<ab>},{<ab>},{<ab>}}", 9))
    test(_TestExample1("{{<!!>},{<!!>},{<!!>},{<!!>}}", 9))
    test(_TestExample1("{{<a!>},{<a!>},{<a!>},{<ab>}}", 3))

    test(_TestExample2("<>", 0))
    test(_TestExample2("<random characters>", 17))
    test(_TestExample2("<<<<>", 3))
    test(_TestExample2("<{!>}>", 2))
    test(_TestExample2("<!!>", 0))
    test(_TestExample2("<!!!>>", 0))
    test(_TestExample2("<{o\"i!a,<{i<a>", 10))

class iso _TestExample1 is UnitTest
  let _stream: String
  let _expected: U64

  new iso create(stream: String, expected: U64) =>
    _stream = stream
    _expected = expected

  fun name(): String => _stream

  fun apply(h: TestHelper) =>
    h.assert_eq[U64](GetGroupScoreAndRemovedCount(_stream)._1, _expected)

class iso _TestExample2 is UnitTest
  let _stream: String
  let _expected: U64

  new iso create(stream: String, expected: U64) =>
    _stream = stream
    _expected = expected

  fun name(): String => _stream

  fun apply(h: TestHelper) =>
    h.assert_eq[U64](GetGroupScoreAndRemovedCount(_stream)._2, _expected)
