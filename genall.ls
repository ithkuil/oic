gen = require \./gen

template = require \./template
data = require \./simple .data


console.log 'data is '
console.log data

gen.fill template, data

console.log "After template filled:"
console.log JSON.stringify template

outs = ''
gen.serialize template.data, (s) -> outs += s

console.log "Final output: "
console.log outs

