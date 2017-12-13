use "collections"
use "logic"
use "part1"
use "part2"

primitive _Part1
primitive _Part2

actor Main
  new create(env: Env) =>
    let part = try
      match env.args(1)?
      | "part1" => _Part1
      | "part2" => _Part2
      else
        error
      end
    else
      _exit(env, "first argument must be 'part1' or 'part2'", 1)
      return
    end

    let start = Array[U64]

    for v in Range[U64](0, 256) do
      start.push(v)
    end

    try
      match part
      | _Part1 =>
        let lengths = try
          Part1.lengths(env.args(2)?)?
        else
          _exit(env, "second argument must be the lengths", 1)
          return
        end

        Part1(env, start, lengths, GenerateHash)?
      | _Part2 =>
        let lengths = try
          Part2.lengths(env.args(2)?)
        else
          _exit(env, "second argument must be the input string", 1)
          return
        end

        Part2(env, start, lengths, GenerateHash)?
      end
    else
      _exit(env, "there was an error generatingt the hash", 2)
      return
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
