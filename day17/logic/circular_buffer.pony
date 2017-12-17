use "collections"

class _BufferElement
  var _next: (_BufferElement | None)
  let _value: U64

  new create(v: U64) =>
    _value = v
    _next = None

  fun ref get_next(): _BufferElement =>
    match _next
    | None =>
      this
    | let b: _BufferElement =>
      b
    end

  fun ref set_next(next: _BufferElement) =>
    _next = next

  fun value(): U64 =>
    _value

  fun ref skip(skip_size: USize): _BufferElement =>
    if skip_size == 0 then
      return this
    end

    match _next
    | None =>
      this
    | let n: _BufferElement =>
      n.skip(skip_size - 1)
    end

  fun ref insert(b: _BufferElement) =>
    let old_next = get_next()
    _next = b
    b.set_next(old_next)

class CircularBuffer
  let _first: _BufferElement

  new create(skip_size: USize, total: USize) =>
    _first = _BufferElement(0)
    _first.set_next(_first)

    var cur = _first

    for i in Range(1, total + 1) do
      cur = cur.skip(skip_size)
      let b = _BufferElement(i.u64())
      cur.insert(b)
      cur = b
    end

  fun ref find(target: U64): _BufferElement =>
    var cur: _BufferElement = _first

    while cur.value() != target do
      cur = cur.get_next()
    end

    cur

  fun ref find_value_after(target: U64): U64 =>
    find(target).get_next().value()

  fun ref string(c: _BufferElement): String =>
    let s = recover trn String end

    s.append(_first.value().string() + " ")

    var cur = _first.get_next()

    while cur isnt _first do
      if cur is c then
        s.append("(" + cur.value().string() + ") ")
      else
        s.append(cur.value().string() + " ")
      end
      cur = cur.get_next()
    end

    consume s
