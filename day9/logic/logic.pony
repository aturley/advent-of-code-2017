primitive GetGroupScoreAndRemovedCount
  fun apply(stream: String): (U64, U64) =>
    var sum: U64 = 0
    var next_group_value: U64 = 1

    (let clean_stream, let removed) = _remove_garbage(stream)

    for c in clean_stream.values() do
      match c
      | '{' =>
        sum = sum + next_group_value
        next_group_value = next_group_value + 1
      | '}' =>
        next_group_value = next_group_value - 1
      end
    end

    (sum, removed)

  fun _remove_garbage(stream: String): (String, U64) =>
    let clean_string = recover trn String end

    var in_garbage = false
    var removed: U64 = 0

    let stream_it = stream.values()

    try
      while stream_it.has_next() do
        match stream_it.next()?
        | '<' =>
          if in_garbage then
            removed = removed + 1
          end
          in_garbage = true
        | '>' =>
          in_garbage = false
        | '!' =>
          // skip next character
          stream_it.next()?
        | let c: U8 =>
          if not in_garbage then
            clean_string.push(c)
          else
            removed = removed + 1
          end
        end
      end
    end

    (consume clean_string, removed)
