use "collections"

primitive Parts
  fun begin_in_state(): String =>
    "Begin in state "

  fun steps(): String =>
    "Perform a diagnostic checksum after "

  fun state_name(): String =>
    "In state "

  fun if_the_current_value_is_0(): String =>
    "If the current value is 0:"

  fun if_the_current_value_is(i: USize): String =>
    "If the current value is " + i.string()

  fun write_the_value(): String =>
    "Write the value "

  fun move_one_slot_to_the(): String =>
    "Move one slot to the "

  fun continue_with_state(): String =>
    "Continue with state "

primitive ActionFromDescription
  fun apply(desc: String): Action ? =>
    let write = _get_write(desc)?
    let move = _get_move(desc)?
    let next_state = _get_next_state(desc)?
    Action(write, move, next_state)

  fun _get_write(desc: String): Mark ? =>
    let write_start = desc.find(Parts.write_the_value())?
    match desc.substring(write_start + Parts.write_the_value().size().isize()).split(".")(0)?
    | "0" =>
      _Zero
    | "1" =>
      _One
    else
      error
    end

  fun _get_move(desc: String): Move ? =>
    let move_start = desc.find(Parts.move_one_slot_to_the())?
    match desc.substring(move_start + Parts.move_one_slot_to_the().size().isize()).split(".")(0)?
    | "left" =>
      _Left
    | "right" =>
      _Right
    else
      error
    end

  fun _get_next_state(desc: String): String ? =>
    let next_state_start = desc.find(Parts.continue_with_state())?
    desc.substring(next_state_start + Parts.continue_with_state().size().isize()).split(".")(0)?

class val Action
  let _write: Mark
  let _move: Move
  let _next_state: String

  new val create(write: Mark, move: Move, next_state: String) =>
    _write = write
    _move = move
    _next_state = next_state

  fun apply(): (Mark, Move, String) =>
    (_write, _move, _next_state)

  fun string(): String =>
    "(" + ",".join([_write.string(); _move.string(); _next_state].values()) + ")"

primitive StateFromDescription
  fun apply(desc: String): State ? =>
    let name = _get_name(desc)?
    (let zero_action, let one_action) = _get_actions(desc)?
    State(name, zero_action, one_action)

  fun _get_name(desc: String): String ? =>
    let start = desc.find(Parts.state_name())?.usize()
    let state_name_start = (start + Parts.state_name().size()).isize()
    recover
      desc.substring(state_name_start).split(":")(0)?.clone().>strip(":")
    end

  fun _get_actions(desc: String): (Action, Action) ? =>
    let actions = Array[Action]
    for i in Range(0, 2) do
      let action_start = desc.find(Parts.if_the_current_value_is(i))?
      actions.push(ActionFromDescription(desc.substring(action_start))?)
    end

    (actions(0)?, actions(1)?)

class val State
  let _name: String
  let _zero_action: Action
  let _one_action: Action

  new val create(name': String, zero_action: Action, one_action: Action) =>
    _name = name'
    _zero_action = zero_action
    _one_action = one_action

  fun apply(pos: ISize, tape: Tape): (Mark, Move, String) =>
    let mark = tape(pos)
    let action = match mark
    | _Zero =>
      _zero_action
    | _One =>
      _one_action
    end
    action()

  fun name(): String =>
    _name

  fun string(): String =>
    let s = recover trn String end
    s.append(_name + ":" + ",".join([_zero_action.string(); _one_action.string()].values()))
    consume s

primitive StateMachineFromDescription
  fun apply(desc: String): StateMachine ? =>
    recover val
      let begin = _get_begin_in_state(desc)?
      let steps = _get_steps(desc)?

      var state_count: USize = 0

      let state_starts = Array[ISize]

      while true do
        try
          state_starts.push(desc.find(Parts.state_name() where nth = state_count)?)
          state_count = state_count + 1
        else
          state_starts.push(desc.size().isize())
          break
        end
      end

      let states = recover trn Map[String, State] end

      for i in Range(0, (state_starts.size() - 1)) do
        let state_start = state_starts(i)?
        let state_end = state_starts(i + 1)?
        let state = (StateFromDescription(desc.substring(state_start, state_end.isize()))?)
        states(state.name()) = state
      end

      StateMachine(begin, steps, consume states)
    end

  fun _get_begin_in_state(desc: String): String ? =>
    let start = desc.find(Parts.begin_in_state())?.usize()
    let state_start = (start + Parts.begin_in_state().size()).isize()
    desc.substring(state_start).split(".")(0)?

  fun _get_steps(desc: String): USize ? =>
    let start = desc.find(Parts.steps())?.usize()
    let steps_start = (start + Parts.steps().size()).isize()
    desc.substring(steps_start).split(" ")(0)?.usize()?

primitive _Zero
  fun string(): String =>
    "0"

primitive _One
  fun string(): String =>
    "1"

type Mark is (_Zero | _One)

primitive _Left
  fun string(): String =>
    "L"

primitive _Right
  fun string(): String =>
    "R"

type Move is (_Left | _Right)

class val StateMachine
  let _begin: String
  let _steps: USize
  let _states: Map[String, State] val

  new create(begin: String, steps: USize, states: Map[String, State] val) =>
    _begin = begin
    _steps = steps
    _states = states

  fun run(tape: Tape) ? =>
    var state = _states(_begin)?
    var pos: ISize = 0

    for _ in Range(0, _steps) do
      (let mark, let move, let state') = state(pos, tape)

      match mark
      | _Zero =>
        tape.zero(pos)
      | _One =>
        tape.one(pos)
      end

      match move
      | _Left =>
        pos = pos - 1
      | _Right =>
        pos = pos + 1
      end

      state = _states(state')?
    end

  fun string(): String =>
    let s = recover trn String end
    for state in _states.values() do
      s.append("[" + state.string() + "] ")
    end
    consume s
