actor Main
  new create(env: Env) =>
    let numbers = try
      _arg_to_numbers(env.args(1)?)
    else
      env.err.print("please supply the input as the argument")
      env.exitcode(1)
      return
    end

    let match_next = _match_next_array(numbers)

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

  fun _match_next_array(numbers: Array[U8] val): Array[Bool] val =>
    let matches = recover trn Array[Bool](numbers.size()) end
    let offset = numbers.clone()
    let last = try offset.pop()? else 0 end
    offset.unshift(last)
    for (i, _) in numbers.pairs() do
      try
        matches.push((numbers(i)? == offset(i)?))
      end
    end

    consume matches
