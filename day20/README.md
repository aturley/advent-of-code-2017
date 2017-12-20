# Day 20

[Here's the problem.](https://adventofcode.com/2017/day/20)

## Running It

```
$ ➜  day20 git:(master) ✗ ./day20 part1 input.txt
308
```

```
➜  day20 git:(master) ✗ ./day20 part2 input.txt
504
```

## Notes

I kind of wonder if it would have been faster to just brute force
these solutions.

The solution to part 1 is tedious but correct.

The solution to part 2 is a little bit of brains and then a guess
based on the fact that the longer the thing runs the less likely you
are to have a collision. But this isn't guaranteed. A pathological
case would be a situation where two particles moving on the same line
are VERY far apart headed in opposite directions, but one has a
negative acceleration so it will eventually turn around; if its
acceleration is greater than the acceleration of the other particle,
and they are phased correctly, they could collide after a long
time. One possible solution would be to run until the distances
between all particles is always increasing. Or you could stop tracking
the fastest particles once they are the farthest away from the origin;
do this repeatedly until you've stopped tracking all the particles.
