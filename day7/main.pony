use "collections"
use "debug"
use "files"

primitive _ProgramAndSubprogramsFromString
  fun apply(s: String): (String, Array[String] val) ? =>
    (_get_program_name(s)?, _get_subprogram_names(s))

  fun _get_program_name(s: String): String ? =>
    s.split(" ")(0)?

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
        (let program, let subprograms) = _ProgramAndSubprogramsFromString(line)?
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
    let auth = try
      env.root as AmbientAuth
    else
      _exit(env, "could not get authority for opening file", 1)
      return
    end

    let input_filename = try
      env.args(1)?
    else
      _exit(env, "first argument must be the input filename", 2)
      return
    end

    let programs = try
      env.out.print(_GetParent(auth, input_filename)?)
    else
      _exit(env, "could not read file '" + input_filename + "'", 3)
      return
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
