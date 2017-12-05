use "files"
use "itertools"

primitive _CheckPassphrase
  fun apply(passphrase: String): Bool =>
    let words = recover val passphrase.split(" ") end

    for (i, word) in words.pairs() do
      try
        words.find(word, i + 1 where predicate={(l, r) => l == r })?
        return false
      end
    end

    true

actor Main
  new create(env: Env) =>
    let filename = try
      env.args(1)?
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
          if not _CheckPassphrase(passphrase) then
            env.out.print("INVALID: '" + passphrase + "'")
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

    env.out.print("valid: " + valid.string() + ", invalid:" + invalid.string())
