use "collections"
use "debug"
use "files"

primitive _Part1
primitive _Part2

primitive _GetUnbalancedProgramAndNewWeight
  fun apply(auth: AmbientAuth, filename: String): String ? =>
    let possible_parents = Set[String]
    let not_parents = Set[String]

    let programs = Map[String, (U64, Array[String] val)]

    let path = FilePath(auth, filename)?

    with file = OpenFile(path) as File do
      for line in file.lines() do
        (let program, let weight, let subprograms) =
          _ProgramAndWeightAndSubprogramsFromString(line)?
        programs(program) = (weight, subprograms)
        possible_parents.set(program)
        for sp in subprograms.values() do
          not_parents.set(sp)
        end
      end
    end

    possible_parents.difference(not_parents.values())

    var parent: String = "NONE"

    for p in possible_parents.values() do
      parent = p
    end

    match _find_unbalanced(programs, parent)?
    | (let program: String, let weight: U64) =>
      program + " should weigh " + weight.string()
    else
      "None"
    end

  fun _find_unbalanced(programs: Map[String, (U64, Array[String] val)],
    parent: String): ((String, U64) | U64) ?
  =>
    if programs(parent)?._2.size() == 0 then
      return programs(parent)?._1
    end

    let child_names = programs(parent)?._2
    let child_weights = Array[U64]
    var child_weight_sum: U64 = 0

    for child in child_names.values() do
      match _find_unbalanced(programs, child)?
      | let w: U64 =>
        child_weights.push(w)
        child_weight_sum = child_weight_sum + w
      | (let program: String, let weight: U64) =>
        return (program, weight)
      end
    end

    for (i, v) in child_weights.pairs() do
      let left_neighbor =
        child_weights(((child_weights.size() + i) - 1) % child_weights.size())?
      let right_neighbor =
        child_weights(((child_weights.size() + i) + 1) % child_weights.size())?
      if (v != left_neighbor) and (v != right_neighbor) then
        let delta = child_weights(i)?.i64() - right_neighbor.i64()
        let new_weight = (programs(programs(parent)?._2(i)?)?._1.i64() - delta).u64()
        return (child_names(i)?, new_weight)
      end
    end

    programs(parent)?._1 + child_weight_sum

primitive _ProgramAndWeightAndSubprogramsFromString
  fun apply(s: String): (String, U64, Array[String] val) ? =>
    (_get_program_name(s)?, _get_program_weight(s)?, _get_subprogram_names(s))

  fun _get_program_name(s: String): String ? =>
    s.split(" ")(0)?

  fun _get_program_weight(s: String): U64 ? =>
    let weight = String
    weight.append(s.split(" ")(1)?)
    weight.strip("()")
    weight.u64()?

  fun _get_subprogram_names(s: String): Array[String] val =>
    let subprogram_names = recover trn Array[String] end

    try
      let subprograms = s.split(">")(1)?
      for name in subprograms.split(",").values() do
        let n = recover trn String end
        n.append(name)
        n.strip()
        subprogram_names.push(consume n)
      end
    end

    consume subprogram_names

primitive _GetParent
  fun apply(auth: AmbientAuth, filename: String): String ? =>
    let possible_parents = Set[String]
    let not_parents = Set[String]

    let path = FilePath(auth, filename)?

    with file = OpenFile(path) as File do
      for line in file.lines() do
        (let program, _, let subprograms) =
          _ProgramAndWeightAndSubprogramsFromString(line)?
        possible_parents.set(program)
        for sp in subprograms.values() do
          not_parents.set(sp)
        end
      end
    end

    possible_parents.difference(not_parents.values())

    var parent: String = "NONE"

    for p in possible_parents.values() do
      parent = p
    end

    parent

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

    let auth = try
      env.root as AmbientAuth
    else
      _exit(env, "could not get authority for opening file", 1)
      return
    end

    let input_filename = try
      env.args(2)?
    else
      _exit(env, "first argument must be the input filename", 2)
      return
    end

    try
      match part
      | _Part1 =>
        env.out.print(_GetParent(auth, input_filename)?)
      | _Part2 =>
        env.out.print(_GetUnbalancedProgramAndNewWeight(auth, input_filename)?)
      end
    else
      _exit(env, "could not read file '" + input_filename + "'", 3)
      return
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
