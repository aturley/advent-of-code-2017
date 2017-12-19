primitive Runner
  fun apply(sc0: SoundComputer, sc1: SoundComputer): (U64, U64) ? =>
    let scs = [sc0; sc1]
    var cur: USize = 0

    while true do
      var progress = false
      let sc = scs(cur)?

      while true do
        match sc.next()?
        | Stopped =>
          break
        else
          progress = true
        end
      end

      if not progress then
        break
      end
      cur = _update_cur(cur)
    end

    (sc0.sends(), sc1.sends())

  fun _update_cur(cur: USize): USize =>
    (cur + 1) % 2
