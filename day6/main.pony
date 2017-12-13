use "collections"

primitive _Part1
primitive _Part2

class BanksCache
  let _seen: Map[U64, Array[(Array[U64], USize)]] =
    Map[U64, Array[(Array[U64], USize)]]

  fun ref add(banks: Array[U64], step: USize) =>
    let sum = _encode_banks(banks)
    let subset = _seen.get_or_else(sum, Array[(Array[U64], USize)])
    subset.push((banks, step))
    _seen(sum) = subset

  fun find(banks: Array[U64] box): (Bool, USize) =>
    let subset = try
      _seen(_encode_banks(banks))?
    else
      return (false, 0)
    end

    for (old_banks, step) in subset.values() do
      var is_a_match = true
      for (i, v) in old_banks.pairs() do
        try
          if v != banks(i)? then
            is_a_match = false
            break
          end
        end
      end
      if is_a_match then
        return (true, step)
      end
    end

    (false, 0)

  fun _encode_banks(banks: Array[U64] box): U64 =>
    var sum: U64 = 0
    for v in banks.values() do
      sum = (sum + 1) xor v
    end
    sum

class Banks
  let _banks: Array[U64]
  let _cache: BanksCache = BanksCache

  new create(banks: Array[U64]) =>
    _banks = banks

  fun ref redistribute(step: USize) =>
    _cache.add(_banks.clone(), step)
    (let max_bank, let blocks) = _find_max_bank()

    try
      _banks(max_bank)? = 0
    end

    for i in Range(0, blocks.usize()) do
      let bank = (i + max_bank + 1) % _banks.size()
      try
        _banks(bank)? = _banks(bank)? + 1
      end
    end

  fun _find_max_bank(): (USize, U64) =>
    var max_idx: USize = 0
    var max_blocks: U64 = 0

    for (i, blocks) in _banks.pairs() do
      if blocks > max_blocks then
        max_blocks = blocks
        max_idx = i
      end
    end

    (max_idx, max_blocks)

  fun was_seen(): (Bool, USize) =>
    _cache.find(_banks)

  fun string(): String =>
    let s: String trn = recover String end

    s.append("[ ")
    for v in _banks.values() do
      s.append(v.string() + " ")
    end
    s.append("]")
    consume s

actor Main
  new create(env: Env) =>
    let banks_array = Array[U64]

    let part = try
      match env.args(1)?
      | "part1" => _Part1
      | "part2" => _Part2
      else
        error
      end
    else
      env.err.print("first argument must be part1 or part2")
      env.exitcode(1)
      return
    end

    try
      for a in env.args.slice(2).values() do
        banks_array.push(a.u64()?)
      end
    else
      env.err.print("args must be numbers of blocks for each bank")
      env.exitcode(1)
      return
    end

    let banks = Banks(banks_array)

    var steps: USize = 0

    while not banks.was_seen()._1 do
      banks.redistribute(steps)
      steps = steps + 1
    end

    let cycle_length = steps - banks.was_seen()._2

    match part
    | _Part1 => env.out.print(steps.string())
    | _Part2 => env.out.print(cycle_length.string())
    end
