use "../../day10/logic"
use "collections"

primitive CalculateHashes
  fun apply(key_base: String): Array[Array[U64]] ? =>
    let hashes = Array[Array[U64]]

    for i in Range(0, 128) do
      let key = key_base + "-" + i.string()
      let key_array = Array[USize]

      for c in key.values() do
        key_array.push(c.usize())
      end

      hashes.push(CalculateHash(key_array)?)
    end

    hashes

primitive CalculateHash
  fun apply(lengths: Array[USize]): Array[U64] ? =>
    let start = Array[U64]

    for i in Range[U64](0, 256) do
      start.push(i)
    end

    var pos: USize = 0
    var step: USize = 0
    for i in Range(0, 64) do
      (pos, step) = GenerateHash(start, _full_lengths(lengths), pos, step)?
    end

    _dense_hash(start)?

  fun _full_lengths(lengths: Array[USize]): Array[USize] =>
    let full_lengths = Array[USize]

    for l in lengths.values() do
      full_lengths.push(l.usize())
    end

    full_lengths.append([as USize: 17; 31; 73; 47; 23])

    full_lengths

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
