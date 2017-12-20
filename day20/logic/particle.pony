use "collections"
use "debug"

type _Triplet is (I64, I64, I64)

primitive ParticleFromString
  fun apply(s: String): Particle ? =>
    // p=<px,py,pz>, v=<vx,vy,vz>, a=<ax,ay,az>
    let particle: Particle ref = Particle

    for p in s.split(" ").values() do
      (let prop, let xyz) = _get_property_x_y(p)?
      match prop
      | "p" =>
        particle.pos(xyz)
      | "v" =>
        particle.vel(xyz)
      | "a" =>
        particle.acc(xyz)
      else
        error
      end
    end

    let acc = particle.get_acc()
    if ((acc._1.abs() + acc._2.abs()) + acc._3.abs()) < 2 then
      Debug(s)
    end

    particle

  fun _get_property_x_y(part: String): (String, _Triplet) ? =>
    // p=<px,py,pz>(,)
    let parts = part.split("=")
    let prop = parts(0)?

    let xyz_string: String ref = parts(1)?.clone()

    xyz_string.strip("<>,")

    let xyz = xyz_string.split(",")
    (prop, (xyz(0)?.i64()?, xyz(1)?.i64()?, xyz(2)?.i64()?))

primitive FindLongTermClosest
  fun apply(particles: Array[Particle]): USize ? =>
    let acc_map = Map[U64, Array[USize]]

    var slowest_acc = _manhattan(particles(0)?.get_acc())

    for (i, part) in particles.pairs() do
      let m_a = _manhattan(part.get_acc())
      if m_a < slowest_acc then
        slowest_acc = m_a
      end
      acc_map.upsert(m_a, [i], {(ps, p_i) => ps.>append(p_i)})?
    end

    let slowest_list = Array[Particle]

    for i in acc_map(slowest_acc)?.values() do
      slowest_list.push(particles(i)?)
    end

    // long term, the closest slowest particle will remain the closest
    // any particle where the signs of vel and acc do not match will eventually change direction
    // figure out how many steps it will take to get to the point where vel signs stop changing
    // find the max number of steps to get all particles to this point
    // at this max, what is each particle's orientation to (0,0)? (toward?, away?)
    // for all heading toward (0,0), which is farthest away? this one is long term farthest

    // find direction changers

    let direction_changers = Array[(Particle, U64)]

    for slow in slowest_list.values() do
      let steps_to_stable_direction = _steps_to_stable_direction(slow)
      if steps_to_stable_direction > 0 then
        direction_changers.push((slow, steps_to_stable_direction))
      end
    end

    if direction_changers.size() == 0 then
      return _closest(slowest_list)?
    end

    var total_steps_to_stable_directions: U64 = 0

    for (particle, steps) in direction_changers.values() do
      total_steps_to_stable_directions = total_steps_to_stable_directions.max(steps)
    end

    for _ in Range(0, total_steps_to_stable_directions.usize()) do
      for (particle, _) in direction_changers.values() do
        particle.update()
      end
    end

    let heading_toward_origin = Array[(Particle, USize)]

    for (p, i) in direction_changers.values() do
      if _heading_toward_origin(p) then
        heading_toward_origin.push((p, particles.find(p)?))
      end
    end

    if heading_toward_origin.size() == 0 then
      // find the one that is already closest
      var closest = direction_changers(0)?._1
      var closest_dist = _manhattan(closest.get_pos())
      for (p, i) in direction_changers.values() do
        let dist = _manhattan(p.get_pos())
        if dist < closest_dist then
          closest = p
          closest_dist = dist
        end
      end
      return particles.find(closest)?
    else
      // find the one that is farthest
      var farthest = heading_toward_origin(0)?._1
      var farthest_dist = _manhattan(farthest.get_pos())
      for (p, i) in heading_toward_origin.values() do
        let dist = _manhattan(p.get_pos())
        if dist > farthest_dist then
          farthest = p
          farthest_dist = dist
        end
      end
      return particles.find(farthest)?
    end

  fun _manhattan(xyz: _Triplet): U64 =>
    xyz._1.abs() + xyz._2.abs() + xyz._3.abs()

  fun _steps_to_stable_direction(p: Particle): U64 =>
    (p.get_vel()._1 / p.get_acc()._1).min(0).min(
      ((p.get_vel()._2 / p.get_acc()._2).min(0))).min(
      ((p.get_vel()._3 / p.get_acc()._3).min(0))).abs()

  fun _closest(particles: Array[Particle]): USize ? =>
    var closest_idx: USize = 0
    var closest_dist = _manhattan(particles(0)?.get_pos())

    for (i, p) in particles.pairs() do
      let dist = _manhattan(p.get_pos())
      if dist < closest_dist then
        closest_idx = i
        closest_dist = dist
      end
    end

    closest_idx

  fun _heading_toward_origin(p: Particle): Bool =>
    (((p.get_acc()._1 > 0) != (p.get_pos()._1 > 0)) or
     ((p.get_acc()._2 > 0) != (p.get_pos()._2 > 0))) or
    ((p.get_acc()._3 > 0) != (p.get_pos()._3 > 0))

class Particle
  var _pos: _Triplet = (0, 0, 0)
  var _vel: _Triplet = (0, 0, 0)
  var _acc: _Triplet = (0, 0, 0)

  fun ref pos(xyz: _Triplet) =>
    _pos = xyz

  fun ref vel(xyz: _Triplet) =>
    _vel = xyz

  fun ref acc(xyz: _Triplet) =>
    _acc = xyz

  fun ref update() =>
    _vel = ((_vel._1 + _acc._1), (_vel._2 + _acc._2), (_vel._3 + _acc._3))
    _pos = ((_pos._1 + _vel._1), (_pos._2 + _vel._2), (_pos._3 + _vel._3))

  fun get_pos(): _Triplet =>
    _pos

  fun get_vel(): _Triplet =>
    _vel

  fun get_acc(): _Triplet =>
    _acc
