use "collections"
use "itertools"

primitive ScoreSequences
  fun apply(a: Generator ref, b: Generator ref, pairs: USize): U64 =>
    var score: U64 = 0

    for _ in Range(0, pairs) do
      a.next()
      b.next()

      if a.lowest_16_bits() == b.lowest_16_bits() then
        score = score + 1
      end
    end

    score

primitive ScoreSequencesWithCriteria
  fun apply(a: Generator ref, b: Generator ref,
    crit_a: {(U64): Bool} val, crit_b: {(U64): Bool} val,
    pairs: USize): U64
  =>
    var score: U64 = 0

    for _ in Range(0, pairs) do
      let av = a.next_with_crit(crit_a)
      let bv = b.next_with_crit(crit_b)

      if a.lowest_16_bits() == b.lowest_16_bits() then
        score = score + 1
      end
    end

    score

primitive GeneratorFromFactorAndSeed
  fun apply(factor: U64, seed: U64): Generator =>
    let fn = recover val
      {(x: U64)(factor): U64 => (x *  factor) % 2147483647}
    end
    Generator(seed, fn)

class Generator
  var _current: U64
  let _calc_next: {(U64): U64} box

  new create(seed: U64, calc_next: {(U64): U64} val) =>
    _current = seed
    _calc_next = calc_next

  fun ref next(): U64 =>
    _current = _calc_next(_current)
    _current

  fun ref next_with_crit(crit: {(U64): Bool} val): U64 =>
    var q: U64 = 0
    while true do
      let n = next()
      if crit(n) then
        break
      end
    end

    _current

  fun lowest_16_bits(): U64 =>
    _current and 0xFFFF
