use "itertools"

primitive _Part1
primitive _Part2

primitive _IncrementByOne
  fun apply(old_value: ISize): ISize =>
    old_value + 1

primitive _Part2Rule
  fun apply(old_value: ISize): ISize =>
    if old_value >= 3 then
      old_value - 1
    else
      old_value + 1
    end

primitive _DoJumps
  fun apply(maze: Array[ISize] ref, modifier: {(ISize): ISize} val,
    pos: USize = 0, count: U64 = 0): U64
  =>
    try
      let offset = maze(pos)?
      maze(pos)? = modifier(maze(pos)?)
      apply(maze, modifier, (pos.isize() + offset).usize(), count + 1)
    else
      count
    end

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

    let modifier = match part
    | _Part1 =>
      _IncrementByOne
    | _Part2 =>
      _Part2Rule
    end

    let maze = Array[ISize]

    for a in env.args.slice(2).values() do
      try
        maze.push(a.isize()?)
      end
    end

    env.out.print(_DoJumps(maze, modifier).string())
