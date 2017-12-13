use "collections"

primitive FindGroups
  fun apply(connections: ProgramConnections):
    Array[Set[String]]
  =>
    let groups = Array[Set[String]]
    let seen: Set[String] = Set[String]
    for p in connections.programs().values() do
      if not seen.contains(p) then
        let group = FindGroup(p, connections)
        groups.push(group)
        seen.union(group.values())
      end
    end
    groups

primitive FindGroup
  fun apply(node: String, connections: ProgramConnections,
    members: Set[String] = Set[String]): Set[String]
  =>
    members.set(node)
    for c in connections.connections_for(node).values() do
      if not members.contains(c) then
        FindGroup(c, connections, members)
      end
    end

    members

class ProgramConnections
  let _connections: Map[String, Set[String]] = Map[String, Set[String]]

  fun ref add_connection(a: String, b: String)? =>
    _connections.upsert(a, Set[String].>set(b),
      {(o: Set[String], n: Set[String]) => o.union(n.values()); o})?

    _connections.upsert(b, Set[String].>set(a),
      {(o: Set[String], n: Set[String]) => o.union(n.values()); o})?

  fun ref connections_for(program_name: String): Set[String] =>
    _connections.get_or_else(program_name, Set[String])

  fun ref programs(): Array[String] =>
    let p = Array[String]
    for n in _connections.keys() do
      p.push(n)
    end
    p
