#read in a list of plugins
fs = require \fs
traverse = require \traverse

showrequire = (s) -> 
  console.log "Using #{s}"
  require s

rungen = (generator) ->
  traverse data .forEach (node) -> generator[node.key] node

build = (plugins) -> 
  map showrequire, plugins
  map rungen, generators 

generators = {}

getgen = (name) ->
  if generators[name]?
    generators[name]
  else
    generators[name] = {}
    generators[name]


#find a method
#that matches the property name
gen = (obj, property, generator) ->
  for property, val of obj
    generator[property]? obj


err, strplugins <-! fs.readFile \plugins, 'utf-8'
if err then throw err
plugins = strplugins.split '\n'
build plugins


