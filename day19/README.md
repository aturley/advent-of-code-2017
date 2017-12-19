# Day 19

[Here's the problem.](https://adventofcode.com/2017/day/19)

## Running It

```
$ ./day19 part1 input.txt
VTWBPYAQFU
```

```
$ ./day19 part2 input.txt
17358
```

## Notes

The `Map` is probably a bit over-engineered. I didn't really need to
make primitives for each of the possible things on the map and then
compile the map into `Array`s of those things, I could have worked
with an `Array[String]`.
