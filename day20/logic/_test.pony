use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestParticle)
    test(_TestParticleParser)
    test(_TestFindLongTermClosest)

class iso _TestParticle is UnitTest
  fun name(): String => "Particle"

  fun apply(h: TestHelper) =>
    let p: Particle ref = Particle
    p.pos((1, 2, 3))
    p.vel((1, 1, 2))
    p.acc((2, 2, 3))

    p.update()
    let pos1 = p.get_pos()
    h.assert_eq[I64](4, pos1._1)
    h.assert_eq[I64](5, pos1._2)
    h.assert_eq[I64](8, pos1._3)

    p.update()
    let pos2 = p.get_pos()
    h.assert_eq[I64](9, pos2._1)
    h.assert_eq[I64](10, pos2._2)
    h.assert_eq[I64](16, pos2._3)

class iso _TestParticleParser is UnitTest
  fun name(): String => "ParticleParser"

  fun apply(h: TestHelper) ? =>
    let p: Particle ref = ParticleFromString(
      "p=<1,2,3>, v=<1,1,2>, a=<2,2,3>")?

    p.update()
    let pos1 = p.get_pos()
    h.assert_eq[I64](4, pos1._1)
    h.assert_eq[I64](5, pos1._2)
    h.assert_eq[I64](8, pos1._3)

    p.update()
    let pos2 = p.get_pos()
    h.assert_eq[I64](9, pos2._1)
    h.assert_eq[I64](10, pos2._2)
    h.assert_eq[I64](16, pos2._3)

class iso _TestFindLongTermClosest is UnitTest
  fun name(): String => "FindLongTermClosest"

  fun apply(h: TestHelper) ? =>
    let p0: Particle ref = ParticleFromString(
      "p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>")?
    let p1: Particle ref = ParticleFromString(
      "p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>")?

    let closest = FindLongTermClosest([p0; p1])?

    h.assert_eq[USize](closest, 0)
