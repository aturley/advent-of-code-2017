# Day 18

[Here's the problem.](https://adventofcode.com/2017/day/18)

## Running It

```
$ ./day18 part1 input.txt
1187
```

```
$ ./day18 part2 input.txt
5969
```

## Notes

Oh boy, a VM! The code for part 2 is a slightly modified version of
part1. I'm not happy about that, but it seemed easier than trying to
make things work with both parts.

The biggest difficulty for me was that I screwed up the way I was
compiling the `jgz` instruction in part 2 (I used the second parsed
argument for both parts of the command), which lead to a subtle
bug. I'd love to say I did something smart to fix it, but it was
mostly just throwing `Debug`s at it.
