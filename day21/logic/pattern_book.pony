use "collections"
use "itertools"

primitive PatternBookFromStrings
  fun apply(strings: Array[String] box): PatternBook ? =>
    // input => output
    let pb = PatternBook
    for pattern in strings.values() do
      let parts = pattern.split(" ")
      let input = parts(0)?
      let output = parts(2)?
      pb.add_pattern(input, output)
    end
    pb

class PatternBook
  let _pattern_table: Map[String, String]

  new create() =>
    _pattern_table = Map[String, String]

  fun ref add_pattern(pattern: String, enhancement: String) =>
    let pattern_array = recover val
      Iter[String](pattern.split("/").values()).
        map[Array[U8] val]({(s): Array[U8] val => s.array()}).
        collect(Array[Array[U8] val])
    end

    var last_pattern = pattern_array

    for _ in Range(0, 2) do
      for _ in Range(0, 4) do
        let ss = recover trn Array[String] end
        for a in last_pattern.values() do
          let s = recover trn String end
          for v in a.values() do
            s.push(v)
          end
          ss.push(consume s)
        end
        let p: String = "/".join((consume ss).values())
        _pattern_table(p) = enhancement
        last_pattern = rot(last_pattern)
      end
      last_pattern = flip(last_pattern)
    end

  fun lookup(pattern: String): String ? =>
    _pattern_table(pattern)?

  fun rot(rect: Array[Array[U8] val] val): Array[Array[U8] val] val =>
    let new_rect = recover trn Array[Array[U8] val] end

    try
      for i in Reverse(rect(0)?.size() - 1, 0) do
        let sub = recover trn Array[U8] end
        for j in Range(0, rect.size()) do
          sub.push(rect(j)?(i)?)
        end
        new_rect.push(consume sub)
      end
    end

    consume new_rect

  fun flip(rect: Array[Array[U8] val] val): Array[Array[U8] val] val =>
    let new_rect = recover trn Array[Array[U8] val] end

    try
      for i in Reverse(rect.size() - 1, 0) do
        let sub = recover trn Array[U8] end
        for j in Range(0, rect(0)?.size()) do
          sub.push(rect(i)?(j)?)
        end
        new_rect.push(consume sub)
      end
    end

    consume new_rect
