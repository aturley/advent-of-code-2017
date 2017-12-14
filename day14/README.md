# Day 14

[Here's the problem.](https://adventofcode.com/2017/day/14)

## Running It

```
$ ./day14 part1 flqrgnkx
8108
```

```
$ ./day14 part2 flqrgnkx
1242
```

## Notes

I used the knot hash logic from day 10. If I had been slightly more
ambitious I would have used [`stable`]() to point to the day 10
folder, but instead I did a relative `use` directive, which is bad and
wrong but I'll just have to live with myself.

There's a lot of ways I could make this code better, including not
creating a whole new grid data structure for part 2 and using arrays
rather than sets in a lot of places.
