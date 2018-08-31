use "debug"
use "ponytest"

primitive _StateMachine
  fun example(): String =>
  """
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
"""

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestStateCount)

class iso _TestStateCount is UnitTest
  fun name(): String => "StateCount"

  fun apply(h: TestHelper) ? =>
    let description = _StateMachine.example()

    let sm = StateMachineFromDescription(description)?

    let tape = Tape

    sm.run(tape)?

    h.assert_eq[USize](3, tape.sum())
