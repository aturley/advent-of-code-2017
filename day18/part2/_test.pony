use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    // test(_TestComputer)
    test(_TestCompiler)

class iso _TestComputer is UnitTest
  fun name(): String => "Computer"

  fun apply(h: TestHelper) ? =>
    let sc0 = SoundComputer(0, recover val Array[Instruction] end)
    let sc1 = SoundComputer(1, recover val Array[Instruction] end)
    sc0.partner(sc1)
    sc1.partner(sc0)

    let ra = _Register("a")?
    sc0.snd(1)?

    h.assert_eq[None](None, sc1.rcv(ra)? as None)
    sc1.rcv(ra)? as Stopped

class iso _TestCompiler is UnitTest
  fun name(): String => "Compiler"

  fun apply(h: TestHelper) ? =>
    let instructions = Compiler.compile(
"""
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d""".split("\n")
      )?
    let sc0 = SoundComputer(0, instructions)
    let sc1 = SoundComputer(1, instructions)
    sc0.partner(sc1)
    sc1.partner(sc0)

    let res = Runner(sc0, sc1)?

    h.assert_eq[U64](3, res._1)
    h.assert_eq[U64](3, res._2)
