primitive HashPopulations
  fun apply(hashes: Array[Array[U64]]): U64 =>
    var total_pop: U64 = 0

    for hash in hashes.values() do
      for x in hash.values() do
        total_pop = total_pop + x.popcount()
      end
    end

    total_pop
