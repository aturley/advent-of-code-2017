use "collections"
use "debug"
use "itertools"
use "files"

primitive _Part1
primitive _Part2

class _Registers
  let _registers: Map[String, I64] = Map[String, I64]
  var _highest: I64 = I64.min_value()

  fun get(register_name: String): I64 =>
    _registers.get_or_else(register_name, 0)

  fun ref inc(register_name: String, amount: I64) =>
    _add_to(register_name, amount)

  fun ref dec(register_name: String, amount: I64) =>
    _add_to(register_name, -amount)

  fun max(): I64 =>
    var max' = I64.min_value()

    for v in _registers.values() do
      if v > max' then
        max' = v
      end
    end

    max'

  fun highest(): I64 =>
    _highest

  fun ref _add_to(register_name: String, amount: I64) =>
    try
      _registers.upsert(register_name, amount,
        {(old: I64, amount: I64): I64 => old + amount})?
      let v = _registers(register_name)?
      if v > _highest then
        _highest = v
      end
    end

primitive _CheckCondition
  fun apply(test_register_name: String, test_condition: String, test_value: I64,
    registers: _Registers): Bool ?
  =>
    let v = registers.get(test_register_name)

    match test_condition
    | ">" =>
      v > test_value
    | "<" =>
      v < test_value
    | ">=" =>
      v >= test_value
    | "<=" =>
      v <= test_value
    | "!=" =>
      v != test_value
    | "==" =>
      v == test_value
    else
      Debug("unrecognized condition '"+ test_condition + "'")
      error
    end

primitive _RunCommand
  fun apply(register_name: String, command: String, amount: I64,
    registers: _Registers) ?
  =>
    match command
    | "inc" =>
      registers.inc(register_name, amount)
    | "dec" =>
      registers.dec(register_name, amount)
    else
      Debug("unrecognized command '"+ command + "'")
      error
    end

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
      _exit(env, "first argument must be either part1 or part2", 1)
      return
    end

    let filename = try
      env.args(2)?
    else
      _exit(env, "second argument must be input filename", 1)
      return
    end

    let registers: _Registers ref = _Registers

    try
      with file = OpenFile(FilePath(env.root as AmbientAuth, filename)?) as File do
        for l in file.lines() do
          let parts = l.split(" ")
          if _CheckCondition(parts(4)?, parts(5)?, parts(6)?.i64()?, registers)? then
            _RunCommand(parts(0)?, parts(1)?, parts(2)?.i64()?, registers)?
          end
        end
      end
    else
      _exit(env, "there was a problem reading the file", 2)
    end

    match part
    | _Part1 =>
      env.out.print(registers.max().string())
    | _Part2 =>
      env.out.print(registers.highest().string())
    end

  fun _exit(env: Env, message: String, exitcode: I32) =>
    env.exitcode(exitcode)
    env.err.print(message)
