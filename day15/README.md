# Day 15

[Here's the problem.](https://adventofcode.com/2017/day/15)

## Running It

```
$ ./day15 part1 634 301
573
$ ./day15 part2 634 301
294
```

## Notes

This was pretty straightforward. I ended up passing around some
anonymous functions to make things more flexible, but that wasn't
really necessary.

I spent about 20 minutes trying to track down a bug that turned out
come from the fact that the result of an reassignment expression is
the old value of the variable, not the new value of the variable. So I
thought I was returning the `_current` value of the generator in
`next()` but I was actually returning the old value of `_current`,
which caused issues when I was trying to find values that matched the
criteria.

As an added bonus, I've included a functional programming-style
solution as well in `functional.pony`.
