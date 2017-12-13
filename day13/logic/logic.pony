use "collections"
use "debug"

primitive CalculateSeverity
  fun apply(scanners: Map[U64, U64] val, delay: U64 = 0): (U64, Bool) =>
    var severity: U64 = 0
    var caught = false
    for (depth, range) in scanners.pairs() do
      let path_length = (range - 1) * 2
      if ((depth + delay) % path_length) == 0 then
        severity = severity + (range * depth)
        caught = true
      end
    end
    (severity, caught)
