use "itertools"

primitive _DoJumps
  fun apply(maze: Array[ISize] ref, pos: USize = 0, count: U64 = 0): U64 =>
    try
      let offset = maze(pos)?
      maze(pos)? = maze(pos)? + 1
      apply(maze, (pos.isize() + offset).usize(), count + 1)
    else
      count
    end

actor Main
  new create(env: Env) =>
    let maze = Array[ISize]

    for a in env.args.slice(1).values() do
      try
        maze.push(a.isize()?)
      end
    end

    env.out.print(_DoJumps(maze).string())
