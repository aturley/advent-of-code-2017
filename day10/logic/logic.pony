use "collections"

class _CircularList
  let _array: Array[U64]

  new create(array': Array[U64]) =>
    _array = array'

  fun ref swap(p1: USize, p2: USize)? =>
    let p1' = p1 % _array.size()
    let p2' = p2 % _array.size()
    let tmp = _array(p1')?

    _array(p1')? = _array(p2')?
    _array(p2')? = tmp

  fun ref reverse(pos: USize, length: USize) ? =>
    for i in Range(0, length / 2) do
      swap(pos + i, (pos + length) - (1 + i))?
    end

  fun ref array(): Array[U64] =>
    _array

primitive GenerateHash
  fun apply(start: Array[U64], lengths: Array[USize], pos': USize,
    skip': USize):
    (USize, USize) ?
  =>
    let list = _CircularList(start)

    var pos: USize = pos'
    var skip: USize = skip'

    for l in lengths.values() do
      list.reverse(pos, l)?
      pos = pos + l + skip
      skip = skip + 1
    end

    (pos, skip)
