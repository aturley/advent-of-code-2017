class val _Snd
  let _arg: (_Register | I64)

  new val create(arg: (_Register | I64)) =>
    _arg = arg

  fun apply(sc: SoundComputer) ? =>
    sc.snd(_arg)?

class val _Set
  let _arg1: _Register
  let _arg2: (_Register | I64)

  new val create(arg1: _Register, arg2: (_Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun apply(sc: SoundComputer) ? =>
    sc.set(_arg1, _arg2)?

class val _Add
  let _arg1: _Register
  let _arg2: (_Register | I64)

  new val create(arg1: _Register, arg2: (_Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun apply(sc: SoundComputer) ? =>
    sc.add(_arg1, _arg2)?

class val _Mul
  let _arg1: _Register
  let _arg2: (_Register | I64)

  new val create(arg1: _Register, arg2: (_Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun apply(sc: SoundComputer) ? =>
    sc.mul(_arg1, _arg2)?

class val _Mod
  let _arg1: _Register
  let _arg2: (_Register | I64)

  new val create(arg1: _Register, arg2: (_Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun apply(sc: SoundComputer) ? =>
    sc.mod(_arg1, _arg2)?

class val _Rcv
  let _arg: (_Register | I64)

  new val create(arg: (_Register | I64)) =>
    _arg = arg

  fun apply(sc: SoundComputer): (I64 | None) ? =>
    sc.rcv(_arg)?

class val _Jgz
  let _arg1: _Register
  let _arg2: (_Register | I64)

  new val create(arg1: _Register, arg2: (_Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun apply(sc: SoundComputer) ? =>
    sc.jgz(_arg1, _arg2)?

type Instruction is (_Snd | _Set | _Add | _Mul | _Mod | _Rcv | _Jgz)
