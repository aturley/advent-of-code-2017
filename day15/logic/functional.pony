use "collections"
use "itertools"

type ScoreLastLast is (U64, U64, U64)
type SeedAndFactor is (U64, U64)

primitive ScoreSequencesFunctional
  fun apply(sf_a: SeedAndFactor, sf_b: SeedAndFactor, pairs: USize): U64 =>
    (let s_a, let f_a) = sf_a
    (let s_b, let f_b) = sf_b
    let fn = recover val {(x: U64, f: U64): U64 => (x * f) % 2147483647 } end

    Iter[USize](Range(0, pairs)).fold[ScoreLastLast]((0, s_a, s_b),
      {(sll: ScoreLastLast, _)(f_a, f_b, fn): ScoreLastLast =>
        (let score, let l_a, let l_b) = sll
        let n_a = fn(l_a, f_a)
        let n_b = fn(l_b, f_b)
        (if ((n_a xor n_b) and 0xFFFF) == 0 then score + 1 else score end,
          n_a, n_b)
        })._1

type SeedAndFactorAndCrit is (U64, U64, {(U64): Bool} val)

primitive ScoreSequencesWithCriteriaFunctional
  fun apply(sfc_a: SeedAndFactorAndCrit, sfc_b: SeedAndFactorAndCrit,
    pairs: USize): U64
  =>
    (let s_a, let f_a, let c_a) = sfc_a
    (let s_b, let f_b, let c_b) = sfc_b
    let fn = recover val
      {(x: U64, f: U64, c: {(U64): Bool} val): U64 =>
        let r = (x * f) % 2147483647
        if c(r) then r else apply(r, f, c) end
      }
    end

    Iter[USize](Range(0, pairs)).fold[ScoreLastLast]((0, s_a, s_b),
      {(sll: ScoreLastLast, _)(f_a, f_b, c_a, c_b, fn): ScoreLastLast =>
        (let score, let l_a, let l_b) = sll
        let n_a = fn(l_a, f_a, c_a)
        let n_b = fn(l_b, f_b, c_b)
        (if ((n_a xor n_b) and 0xFFFF) == 0 then score + 1 else score end,
          n_a, n_b)
        })._1
