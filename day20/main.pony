use "debug"
use "files"
use "logic"

primitive _Part1
primitive _Part2

actor Main
  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)

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

    let input_filename = try
      env.args(2)?
    else
      _exit(env, "second argument must be the input filename", 1)
      return
    end

    let file_contents: String = try
      var s: String = ""
      let path = FilePath(env.root as AmbientAuth, input_filename)?
      with file = OpenFile(path) as File do
        s = String.from_array(file.read(file.size()))
      end
      s
    else
      _exit(env, "error reading " + input_filename, 1)
      return
    end

    match part
    | _Part1 =>
      try
        let particles = Array[Particle]
        for (i, p) in file_contents.split("\n").pairs() do
          particles.push(ParticleFromString(p)?)
        end

        env.out.print(FindLongTermClosest(particles)?.string())
      else
        _exit(env, "error finding long term closest", 1)
        return
      end
    | _Part2 =>
      try
        let particles = Array[Particle]
        for (i, p) in file_contents.split("\n").pairs() do
          particles.push(ParticleFromString(p)?)
        end

        env.out.print(FindAliveAfterCollisions(particles)?.string())
      else
        _exit(env, "error finding particles left", 1)
        return
      end
    end
