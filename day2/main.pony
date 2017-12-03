use "itertools"

primitive _HiLowDifference
  fun apply(row: Iter[I64]): I64 =>
    let first = try row.next()? else 0 end
    let min_max = row.fold[(I64, I64)]((first, first),
      {(min_max: (I64, I64), v: I64): (I64, I64) =>
        (min_max._1.min(v), min_max._2.max(v))
      })
    min_max._2 - min_max._1

actor Main
  new create(env: Env) =>
    let input = try
      env.args(1)?
    else
      env.err.print("First argument must be the input")
      env.exitcode(1)
      return
    end

    let rows = Iter[String](input.split("\n").values()).map[Iter[I64]](
      {(row: String): Iter[I64] =>
        Iter[String](row.split("\t").values()).map[I64](
          {(value: String): I64 => try value.i64()? else 0 end})
      })

    let sum = Iter[Iter[I64]](rows).map[I64](
      {(row: Iter[I64]): I64 => _HiLowDifference(row)}).fold[I64](
        0, {(sum, x) => sum + x
      })

    env.out.print(sum.string())
