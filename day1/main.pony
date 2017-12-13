use "collections"

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

    let numbers = try
      _arg_to_numbers(env.args(2)?)
    else
      env.err.print("please supply the input as the second argument")
      env.exitcode(1)
      return
    end

    let match_offset: ISize = match part
    | _Part1 =>
      -1
    | _Part2 =>
      (numbers.size() / 2).isize()
    end

    let match_next = _match_next_array(numbers, match_offset)

    var sum: U64 = 0

    for (i, m) in match_next.pairs() do
      if m then
        sum = sum + try numbers(i)?.u64() else 0 end
      end
    end

    env.out.print(sum.string())

  fun _arg_to_numbers(arg: String): Array[U8] val =>
    let numbers = recover trn Array[U8](arg.size()) end
    for a in arg.values() do
      numbers.push(a - 48)
    end
    consume numbers

  fun _match_next_array(numbers: Array[U8] val, shift: ISize = -1):
    Array[Bool] val
  =>
    let matches = recover trn Array[Bool](numbers.size()) end

    let shift' = if shift < 0 then
      (numbers.size().isize() + shift).usize()
    else
      shift.usize()
    end

    for i in Range(0, numbers.size()) do
      try
        matches.push((numbers(i)? == numbers((i + shift') % numbers.size())?))
      end
    end

    consume matches
