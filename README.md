# Advent of Code 2017

This is a repository of solutions to
the [Advent of Code 2017](https://adventofcode.com/2017) challenges. I
haven't thought very hard about these solutions, they're kind of the
simplest thing I could think of to solve the problems. There will be
some brute force and a few places where I've completely given up on a
good solution.

I'll be using [Pony](https://ponylang.org) to solve these problems. I
work with Pony at my job at [Wallaroo Labs](https://wallaroolabs.com),
but the language is evolving and sometimes I don't get to try out all
of the new features and libraries, so I'm trying to do that
occassionally with this project. For example, this is my first time
playing around with the new `itertools` library.

## Build the Programs

You should be able to build each of the solutions by running the Pony
compiler (version 0.20.0) in the directory like this:

```
ponyc .
```

That should produce an executable with the same name as the directory
you are in. So for example, to build the `day8` solution, you would
run `ponyc .` in the `day8` directory.

## Running the Programs

These programs take two arguments at the commandline:

* either `part1` or `part2` to indicate which problem they are solving
* an input list or an input file, depending on how I felt like
  entering the problem
