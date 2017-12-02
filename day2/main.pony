use "itertools"

primitive _HiLowDifference
  fun apply(row: Iter[I64]): I64 =>
    var hi: (None | I64) = None
    var low: (None | I64) = None

    for v in row do
      match hi
      | let h: I64 if v > h =>
        hi = v
      | None =>
        hi = v
      end

      match low
      | let l: I64 if v < l =>
        low = v
      | None =>
        low = v
      end
    end

    match (hi, low)
    | (let h: I64, let l: I64) =>
      h - l
    else
      0
    end

actor Main
  new create(env: Env) =>
    let input = try
      env.args(1)?
    else
      env.err.print("First argument must be the input")
      env.exitcode(1)
      return
    end

    let rows = Iter[String](input.split("\n").values()).
      map[Iter[I64]](
        {(row: String): Iter[I64] =>
          Iter[String](row.split("\t").values()).map[I64](
            {(value: String): I64 => try value.i64()? else 0 end})
        })

    let sum = Iter[Iter[I64]](rows).map[I64](
      {(row: Iter[I64]): I64 => _HiLowDifference(row)}).fold[I64](
        0, {(sum, x) => sum + x })

    env.out.print(sum.string())
