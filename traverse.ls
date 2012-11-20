Traverse = (obj) ->
  @value = obj
walk = (root, cb, immutable) ->
  path = []
  parents = []
  alive = true
  
  # use return values to update if defined
  (walker = (node_) ->
    updateState = ->
      if typeof state.node is "object" and state.node isnt null
        state.keys = objectKeys(state.node)  if not state.keys or state.node_ isnt state.node
        state.isLeaf = state.keys.length is 0
        i = 0

        while i < parents.length
          if parents[i].node_ is node_
            state.circular = parents[i]
            break
          i++
      else
        state.isLeaf = true
        state.keys = null
      state.notLeaf = not state.isLeaf
      state.notRoot = not state.isRoot
    node = (if immutable then copy(node_) else node_)
    modifiers = {}
    keepGoing = true
    state =
      node: node
      node_: node_
      path: [].concat(path)
      parent: parents[parents.length - 1]
      parents: parents
      key: path.slice(-1)[0]
      isRoot: path.length is 0
      level: path.length
      circular: null
      update: (x, stopHere) ->
        state.parent.node[state.key] = x  unless state.isRoot
        state.node = x
        keepGoing = false  if stopHere

      delete: (stopHere) ->
        delete state.parent.node[state.key]

        keepGoing = false  if stopHere

      remove: (stopHere) ->
        if isArray(state.parent.node)
          state.parent.node.splice state.key, 1
        else
          delete state.parent.node[state.key]
        keepGoing = false  if stopHere

      keys: null
      before: (f) ->
        modifiers.before = f

      after: (f) ->
        modifiers.after = f

      pre: (f) ->
        modifiers.pre = f

      post: (f) ->
        modifiers.post = f

      stop: ->
        alive = false

      block: ->
        keepGoing = false

    return state  unless alive
    updateState()
    ret = cb.call(state, state.node)
    state.update ret  if ret isnt `undefined` and state.update
    modifiers.before.call state, state.node  if modifiers.before
    return state  unless keepGoing
    if typeof state.node is "object" and state.node isnt null and not state.circular
      parents.push state
      updateState()
      forEach state.keys, (key, i) ->
        path.push key
        modifiers.pre.call state, state.node[key], key  if modifiers.pre
        child = walker(state.node[key])
        state.node[key] = child.node  if immutable and Object.hasOwnProperty.call(state.node, key)
        child.isLast = i is state.keys.length - 1
        child.isFirst = i is 0
        modifiers.post.call state, child  if modifiers.post
        path.pop()

      parents.pop()
    modifiers.after.call state, state.node  if modifiers.after
    state
  )(root).node
copy = (src) ->
  if typeof src is "object" and src isnt null
    dst = undefined
    if isArray(src)
      dst = []
    else if isDate(src)
      dst = new Date(src)
    else if isRegExp(src)
      dst = new RegExp(src)
    else if isError(src)
      dst = message: src.message
    else if isBoolean(src)
      dst = new Boolean(src)
    else if isNumber(src)
      dst = new Number(src)
    else if isString(src)
      dst = new String(src)
    else if Object.create and Object.getPrototypeOf
      dst = Object.create(Object.getPrototypeOf(src))
    else if src.constructor is Object
      dst = {}
    else
      proto = (src.constructor and src.constructor::) or src.__proto__ or {}
      T = ->

      T:: = proto
      dst = new T
    forEach objectKeys(src), (key) ->
      dst[key] = src[key]

    dst
  else
    src
toS = (obj) ->
  Object::toString.call obj
isDate = (obj) ->
  toS(obj) is "[object Date]"
isRegExp = (obj) ->
  toS(obj) is "[object RegExp]"
isError = (obj) ->
  toS(obj) is "[object Error]"
isBoolean = (obj) ->
  toS(obj) is "[object Boolean]"
isNumber = (obj) ->
  toS(obj) is "[object Number]"
isString = (obj) ->
  toS(obj) is "[object String]"
traverse = module.exports = (obj) ->
  new Traverse(obj)

Traverse::get = (ps) ->
  node = @value
  i = 0

  while i < ps.length
    key = ps[i]
    unless Object.hasOwnProperty.call(node, key)
      node = `undefined`
      break
    node = node[key]
    i++
  node

Traverse::has = (ps) ->
  node = @value
  i = 0

  while i < ps.length
    key = ps[i]
    return false  unless Object.hasOwnProperty.call(node, key)
    node = node[key]
    i++
  true

Traverse::set = (ps, value) ->
  node = @value
  i = 0

  while i < ps.length - 1
    key = ps[i]
    node[key] = {}  unless Object.hasOwnProperty.call(node, key)
    node = node[key]
    i++
  node[ps[i]] = value
  value

Traverse::map = (cb) ->
  walk @value, cb, true

Traverse::forEach = (cb) ->
  @value = walk(@value, cb, false)
  @value

Traverse::reduce = (cb, init) ->
  skip = arguments_.length is 1
  acc = (if skip then @value else init)
  @forEach (x) ->
    acc = cb.call(this, acc, x)  if not @isRoot or not skip

  acc

Traverse::paths = ->
  acc = []
  @forEach (x) ->
    acc.push @path

  acc

Traverse::nodes = ->
  acc = []
  @forEach (x) ->
    acc.push @node

  acc

Traverse::clone = ->
  parents = []
  nodes = []
  (clone = (src) ->
    i = 0

    while i < parents.length
      return nodes[i]  if parents[i] is src
      i++
    if typeof src is "object" and src isnt null
      dst = copy(src)
      parents.push src
      nodes.push dst
      forEach objectKeys(src), (key) ->
        dst[key] = clone(src[key])

      parents.pop()
      nodes.pop()
      dst
    else
      src
  ) @value

objectKeys = Object.keys or keys = (obj) ->
  res = []
  for key of obj
    res.push key
  res

isArray = Array.isArray or isArray = (xs) ->
  Object::toString.call(xs) is "[object Array]"

forEach = (xs, fn) ->
  if xs.forEach
    xs.forEach fn
  else
    i = 0

    while i < xs.length
      fn xs[i], i, xs
      i++

forEach objectKeys(Traverse::), (key) ->
  traverse[key] = (obj) ->
    args = [].slice.call(arguments_, 1)
    t = new Traverse(obj)
    t[key].apply t, args

