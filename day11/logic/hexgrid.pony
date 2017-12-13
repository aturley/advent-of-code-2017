primitive RunTravelerScript
  fun apply(traveler: HexTraveler ref, script: String) ? =>
    for move in script.split(",").values() do
      match move
      | "n" =>
        traveler.n()
      | "s" =>
        traveler.s()
      | "nw" =>
        traveler.nw()
      | "ne" =>
        traveler.ne()
      | "sw" =>
        traveler.sw()
      | "se" =>
        traveler.se()
      else
        error
      end
    end

class HexTraveler
  var _x: I64 = 0
  var _y: I64 = 0
  var _z: I64 = 0
  var _furthest: I64 = 0

  fun ref n() =>
    _y = _y + 1
    _z = _z - 1
    _furthest = _furthest.max(distance_from_origin())

  fun ref s() =>
    _y = _y - 1
    _z = _z + 1
    _furthest = _furthest.max(distance_from_origin())

  fun ref nw() =>
    _x = _x - 1
    _y = _y + 1
    _furthest = _furthest.max(distance_from_origin())

  fun ref ne() =>
    _x = _x + 1
    _z = _z - 1
    _furthest = _furthest.max(distance_from_origin())

  fun ref sw() =>
    _x = _x - 1
    _z = _z + 1
    _furthest = _furthest.max(distance_from_origin())

  fun ref se() =>
    _x = _x + 1
    _y = _y - 1
    _furthest = _furthest.max(distance_from_origin())

  fun distance_from_origin(): I64 =>
    _x.max(0) + _y.max(0) + _z.max(0)

  fun furthest(): I64 =>
    _furthest
