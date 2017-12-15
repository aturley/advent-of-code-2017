use "collections"
use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestExample1)
    test(_TestExample2)
    test(_TestExample1Functional)
    test(_TestExample2Functional)

class iso _TestExample1 is UnitTest
  fun name(): String => "Example 1"

  fun apply(h: TestHelper) =>
    let gen_a = GeneratorFromFactorAndSeed(16807, 65)
    let gen_b = GeneratorFromFactorAndSeed(48271, 8921)
    h.assert_eq[U64](ScoreSequences(gen_a, gen_b, 5), 1)

class iso _TestExample2 is UnitTest
  fun name(): String => "Example 2"

  fun apply(h: TestHelper) =>
    let gen_a = GeneratorFromFactorAndSeed(16807, 65)
    let crit_a = recover val {(x: U64): Bool => (x % 4) == 0} end

    let gen_b = GeneratorFromFactorAndSeed(48271, 8921)
    let crit_b = recover val {(x: U64): Bool => (x % 8) == 0} end

    h.assert_eq[U64](ScoreSequencesWithCriteria(gen_a, gen_b, crit_a, crit_b,
      5_000_000), 309)

class iso _TestExample1Functional is UnitTest
  fun name(): String => "Example 1 Functional"

  fun apply(h: TestHelper) =>
    h.assert_eq[U64](
      ScoreSequencesFunctional((65, 16807), (8921, 48271), 5), 1)

class iso _TestExample2Functional is UnitTest
  fun name(): String => "Example 2 Functional"

  fun apply(h: TestHelper) =>
    h.assert_eq[U64](
      ScoreSequencesWithCriteriaFunctional(
        (65, 16807, recover {(x: U64): Bool => x % 4 == 0} end),
        (8921, 48271, recover {(x: U64): Bool => x % 8 == 0} end),
        5_000_000), 309)
