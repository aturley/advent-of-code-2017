use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestComputer)
    test(_TestCompiler)

class iso _TestComputer is UnitTest
  fun name(): String => "Computer"

  fun apply(h: TestHelper) ? =>
    let sc = SoundComputer(recover val Array[Instruction] end)
    h.assert_eq[None](None, sc.rcv(1)? as None)
    sc.snd(10)?
    h.assert_eq[I64](10, sc.rcv(1)? as I64)
    let ra = _Register("a")?
    let rb = _Register("b")?

    sc.set(ra, 1)?
    sc.set(rb, 0)?

    h.assert_eq[I64](10, sc.rcv(ra)? as I64)
    h.assert_eq[None](None, sc.rcv(rb)? as None)

class iso _TestCompiler is UnitTest
  fun name(): String => "Compiler"

  fun apply(h: TestHelper) ? =>
    let instructions = Compiler.compile(
"""
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2""".split("\n")
      )?
    let sc = SoundComputer(instructions)

    var freq: I64 = 0

    while true do
      match sc.next()?
      | let f: I64 =>
        freq = f
        break
      end
    end

    h.assert_eq[I64](4, freq)
