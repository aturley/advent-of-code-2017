use "collections"
use "format"

primitive Part2
  fun apply(env: Env, start: Array[U64], lengths': Array[USize],
    fn: {(Array[U64], Array[USize], USize, USize): (USize, USize) ?} val) ?
  =>
    var pos: USize = 0
    var step: USize = 0
    for i in Range(0, 64) do
      (pos, step) = fn(start, lengths', pos, step)?
    end
    env.out.print(_hex(_dense_hash(start)?))

  fun lengths(input: String): Array[USize] =>
    let lengths' = Array[USize]

    for c in input.values() do
      lengths'.push(c.usize())
    end

    lengths'.append([as USize: 17; 31; 73; 47; 23])

    lengths'

  fun _dense_hash(hash_array: Array[U64]): Array[U64] ? =>
    let dense_hash = Array[U64]
    for i in Range(0, 256, 16) do
      var sum: U64 = 0
      for j in Range(0, 16) do
        sum = sum xor hash_array(i + j)?
      end
      dense_hash.push(sum)
    end
    dense_hash

  fun _hex(array: Array[U64]): String =>
    let s = recover trn String end

    for v in array.values() do
      s.append(Format.int[U64](v, FormatHexSmallBare, PrefixDefault, 2))
    end

    consume s
