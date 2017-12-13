primitive FindNextOddSquareRoot
  fun apply(number: U64): U64 =>
    let next_sqrt = match number.f64().sqrt().u64()
    | let n: U64 if (n * n) == number =>
      n
    | let n: U64 =>
      n + 1
    end

    match next_sqrt % 2
    | 0 => next_sqrt + 1
    else next_sqrt
    end

primitive FindClosestCornerDistance
  fun apply(number: U64, sqrt: U64): U64 =>
    """
      +- s2 -+
      |      |
      s1     s3
      |      |
      +- s0 -max

    The maximum value in the square will be `sqrt * sqrt`.

    The length of each side of the square will be `sqrt - 1`.

    The offset of a number is it's distance along the perimeter from `max`.

    The number will appear on one of the sides of the square.

    The two corners nearest the number are the "high corner" and "low corner".
    """
    let max = sqrt * sqrt
    let side_length = sqrt - 1
    let offset = max - number - 1
    let side = offset / side_length

    let high_corner_dist = ((max - (side * side_length)) - number)
    let low_corner_dist = number - (max - ((side + 1) * side_length))
    high_corner_dist.min(low_corner_dist)

primitive Part1
  fun apply(env: Env, target: U64) =>
    let next_odd_square = FindNextOddSquareRoot(target)
    let closest_corner_distance = FindClosestCornerDistance(target, next_odd_square)
    let center_to_edge_dist = next_odd_square / 2
    let edge_to_target_dist = center_to_edge_dist - closest_corner_distance
    let m_distance = center_to_edge_dist + edge_to_target_dist
    env.out.print(m_distance.string())
