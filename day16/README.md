# Day 16

[Here's the problem.](https://adventofcode.com/2017/day/16)

## Running It

```
$ ./day16 part1 s1,x3/4,pe/b
paedcbfghijklmno
```

```
$ ./day16 part2 s1,x3/4,pe/b
ghidjklmnopabcef
```

## Notes

Part 1 pretty easy. Part 2 was a bit of a trick for me. The idea is to
run part 1 a billion times. My very first attempt basically crashed my
computer because everything was happening inside one actor behavior,
so there was no garbage collection and I ran out of memory. So I broke
it out so that it would recursively call the behavior after doing some
work.

This version was still very slow. I was parsing all the commands each
time. So first I made some changes to compile the commands into
objects so that I wouldn't have to parse the strings each time. That
still wasn't fast enough (it was on track to take about 4 days to run
all the calculations). So I started looking for other optimizations. I
got rid of some for-loops and built an index so so that I would always
know where a letter was for `partner` operations. It was still too
slow.

I was on Twitter and saw a tweet about noticing a pattern, and so I
memoized my results used that to jump to the end once I saw a cycle.
