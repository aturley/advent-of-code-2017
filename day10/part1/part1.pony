primitive Part1
  fun apply(env: Env, start: Array[U64], lengths': Array[USize],
    fn: {(Array[U64], Array[USize], USize, USize): (USize, USize) ?} val) ?
  =>
    fn(start, lengths', 0, 0)?
    env.out.print((start(0)? * start(1)?).string())

  fun lengths(input: String): Array[USize] ? =>
    let inputs = recover val input.split(",") end
    let lengths' = Array[USize]
    for l in inputs.values() do
      lengths'.push(l.usize()?)
    end
    lengths'
