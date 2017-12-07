use "collections"

class BanksCache
  let _seen: Map[U64, Array[Array[U64]]] = Map[U64, Array[Array[U64]]]

  fun ref add(banks: Array[U64]) =>
    let sum = _encode_banks(banks)
    let subset = _seen.get_or_else(sum, Array[Array[U64]])
    subset.push(banks)
    _seen(sum) = subset

  fun find(banks: Array[U64] box): Bool =>
    let subset = try
      _seen(_encode_banks(banks))?
    else
      return false
    end

    for old_banks in subset.values() do
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
        return true
      end
    end

    false

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

  fun ref redistribute() =>
    _cache.add(_banks.clone())
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

  fun was_seen(): Bool =>
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

    try
      for a in env.args.slice(1).values() do
        banks_array.push(a.u64()?)
      end
    else
      env.err.print("args must be numbers of blocks for each bank")
      env.exitcode(1)
      return
    end

    let banks = Banks(banks_array)

    var cycles: U64 = 0

    while not banks.was_seen() do
      banks.redistribute()
      cycles = cycles + 1
    end

    env.out.print(cycles.string())
