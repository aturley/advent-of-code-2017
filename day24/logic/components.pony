use "collections"
use "debug"

primitive ScoreBridgesWithLength
  fun apply(bridges: Array[Array[Component]]): USize =>
    var max_length: USize = 0

    for br in bridges.values() do
      max_length = max_length.max(br.size())
    end

    var max: USize = 0

    for br in bridges.values() do
      if br.size() == max_length then
        let sum = SumComponents(br)
        Debug("sum=" + sum.string())
        max = max.max(sum)
      end
    end

    max

primitive ScoreBridges
  fun apply(bridges: Array[Array[Component]]): USize =>
    var max: USize = 0

    for c in bridges.values() do
      let sum = SumComponents(c)
      Debug("sum=" + sum.string())
      max = max.max(sum)
    end

    max

primitive BuildBridges
  fun apply(components: Array[Component] box, cmap: Map[USize, Array[Component]]): Array[Array[Component]] ? =>
    let combinations = Array[Array[Component]]

    for c in cmap(0)?.values() do
      for p in GetCombinations([c], if c.a == 0 then c.b else c.a end, cmap).values() do
        combinations.push(p)
        Debug(",".join(p.values()))
      end
    end

    combinations

primitive SumComponents
  fun apply(components: Array[Component] box): USize =>
    var sum: USize = 0
    for c in components.values() do
      sum = sum + c.sum()
    end
    sum

primitive GetCombinations
  fun apply(components: Array[Component] box, next: USize, cmap: Map[USize, Array[Component]]): Array[Array[Component]] =>
    let component_combinations = Array[Array[Component]]
    for c in cmap.get_or_else(next, []).values() do
      Debug("component = " + c.string())
      if not components.contains(c, {(c1, c2): Bool => c1 == c2}) then
        Debug("not in list!")
        let next' = if c.a == next then c.b else c.a end
        let parts = apply(components.clone().>push(c), next', cmap)
        for p in parts.values() do
          component_combinations.>push(p)
        end
      end
    end

    if component_combinations.size() == 0 then
      component_combinations.push(components.clone())
    end

    component_combinations

primitive ComponentsMapFromComponents
  fun apply(components: Array[Component] val):
    Map[USize, Array[Component]] ?
  =>
    let m = Map[USize, Array[Component]]
    for c in components.values() do
      m.upsert(c.a, [c], {(cs, c): Array[Component] => cs.>append(c)})?
      m.upsert(c.b, [c], {(cs, c): Array[Component] => cs.>append(c)})?
    end
    m

primitive ComponentsFromString
  fun apply(s: String): Array[Component] val ? =>
    let components = recover trn Array[Component] end
    for c in s.split("\n").values() do
      components.push(ComponentFromString(c)?)
    end
    consume components

primitive ComponentFromString
  fun apply(s: String): Component ? =>
    let parts = s.split("/")
    Component(parts(0)?.usize()?, parts(1)?.usize()?)

class val Component
  let a: USize
  let b: USize

  new val create(a': USize, b': USize) =>
    a = a'
    b = b'

  fun eq(other: Component box): Bool =>
    (a == other.a) and (b == other.b)

  fun hash(): U64 =>
    (a * 1024).u64() + b.u64()

  fun sum(): USize =>
    a + b

  fun string(): String iso^ =>
    ("(" + a.string() + "," + b.string() + ")").clone()
