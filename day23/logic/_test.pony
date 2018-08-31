use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestSet)
    test(_TestMul)
    test(_TestMulLoop)
    test(_TestNoDebugMulLoop)

class iso _TestSet is UnitTest
  fun name(): String => "Set"

  fun apply(h: TestHelper) ? =>
    let code = "set a 1"
    let instructions = Compiler.compile(code) as Array[Instruction] val
    let proc = Processor(instructions, true)

    try
      while true do
        proc.next()?
      end
    end

    h.assert_eq[USize](0, proc.mul_count())

class iso _TestMul is UnitTest
  fun name(): String => "Mul"

  fun apply(h: TestHelper) ? =>
    let code = "mul a 1"
    let instructions = Compiler.compile(code) as Array[Instruction] val
    let proc = Processor(instructions, true)

    try
      while true do
        proc.next()?
      end
    end

    h.assert_eq[USize](1, proc.mul_count())

class iso _TestMulLoop is UnitTest
  fun name(): String => "MulLoop"

  fun apply(h: TestHelper) ? =>
    let code = """
set b 3
sub b a
mul b b
mul a 1
sub b 1
jnz b -2"""
    let instructions = Compiler.compile(code) as Array[Instruction] val
    let proc = Processor(instructions, true)

    try
      while true do
        proc.next()?
      end
    end

    h.assert_eq[USize](10, proc.mul_count())

class iso _TestNoDebugMulLoop is UnitTest
  fun name(): String => "MulLoop"

  fun apply(h: TestHelper) ? =>
    let code = """
set b 3
sub b a
mul b b
mul a 1
sub b 1
jnz b -2"""
    let instructions = Compiler.compile(code) as Array[Instruction] val
    let proc = Processor(instructions, false)

    try
      while true do
        proc.next()?
      end
    end

    h.assert_eq[USize](5, proc.mul_count())
