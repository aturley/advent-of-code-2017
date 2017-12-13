use "itertools"

primitive _InputToRows
  fun apply(input: String): Iter[Iter[I64]] =>
    Iter[String](input.split("\n").values()).map[Iter[I64]](
      {(row: String): Iter[I64] =>
        Iter[String](row.split(" \t").values()).map[I64](
          {(value: String): I64 => try value.i64()? else 0 end})})

primitive _EvenlyDivisibleDivide
  fun apply(row: Iter[I64]): I64 ? =>
    (_, let r) = row.fold[(Array[I64], ((I64, I64) | None))](([], None),
      {(array_result: (Array[I64], ((I64, I64) | None)), v: I64): (Array[I64], ((I64, I64) | None)) =>
        let array = array_result._1
        let result = try
          (v, Iter[I64](array.values()).find(
             {(x: I64)(v): Bool => ((v % x) == 0) or ((x % v) == 0)})?)
        else
          array_result._2
        end
        array.push(v)
        (array, result)})
    (let a, let b) = r as (I64, I64)
    a.max(b) / a.min(b)

primitive _HiLowDifference
  fun apply(row: Iter[I64]): I64 ? =>
    let first = row.next()?
    let min_max = row.fold[(I64, I64)]((first, first),
      {(min_max: (I64, I64), v: I64): (I64, I64) =>
        (min_max._1.min(v), min_max._2.max(v))})
    min_max._2 - min_max._1

primitive _CalculateChecksum
  fun apply(rows: Iter[Iter[I64]], fn: {(Iter[I64]): I64 ?} val): I64 =>
    Iter[Iter[I64]](rows).map[I64](
      {(row: Iter[I64]): I64 ? => fn(row)?}).fold[I64](
        0, {(sum, x) => sum + x})

primitive _Part1
primitive _Part2

actor Main
  new create(env: Env) =>
    let part = try
      match env.args(1)?
      | "part1" =>
        _Part1
      | "part2" =>
        _Part2
      else
        error
      end
    else
      env.err.print("please supply 'part1' or 'part2' as the first argument")
      env.exitcode(1)
      return
    end

    let input = try
      env.args(2)?
    else
      env.err.print("the second argument must be the input")
      env.exitcode(1)
      return
    end

    let rows = _InputToRows(input)

    let sum = _CalculateChecksum(rows, match part
      | _Part1 =>
        _HiLowDifference
      | _Part2 =>
        _EvenlyDivisibleDivide
      end)

    env.out.print(sum.string())
