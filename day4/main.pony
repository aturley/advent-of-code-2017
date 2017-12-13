use "collections"
use "files"
use "itertools"

primitive _Part1
primitive _Part2

primitive _CheckPassphrase
  fun apply(passphrase: String, no_anagrams: Bool = false): Bool =>
    let words = recover val passphrase.split(" ") end

    let words_to_use = if not no_anagrams then
      words
    else
      let sorted_words = recover trn Array[String] end

      for word in words.values() do
        let word' = recover val
          let new_word_array = Array[U8](word.size())
          word.array().copy_to(new_word_array, 0, 0, word.size())
          Sort[Array[U8], U8](new_word_array)
        end
        sorted_words.push(String.from_array(word'))
      end
      consume sorted_words
    end

    for (i, word) in words_to_use.pairs() do
      try
        words_to_use.find(word, i + 1 where predicate={(l, r) => l == r })?
        return false
      end
    end

    true

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

    let filename = try
      env.args(2)?
    else
      env.err.print("first arg must be the name of the input file")
      env.exitcode(1)
      return
    end

    let auth = try
      env.root as AmbientAuth
    else
      env.err.print("error getting auth")
      env.exitcode(1)
      return
    end

    var valid: U64 = 0
    var invalid: U64 = 0

    try
      let path = FilePath(auth, filename)?
      with f = OpenFile(path) as File do
        for passphrase in f.lines() do
          let no_anagrams = match part
          | _Part1 =>
            false
          | _Part2 =>
            true
          end

          if not _CheckPassphrase(passphrase, no_anagrams) then
            invalid = invalid + 1
          else
            valid = valid + 1
          end
        end
      end
    else
      env.err.print("could not open file")
      env.exitcode(1)
      return
    end

    env.out.print("valid: " + valid.string() + ", invalid: " + invalid.string())
