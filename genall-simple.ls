gen = require \./gen

require! {'./template' './simple'.data}

console.log 'data is '
console.log data

gen.fill template, data

console.log "After template filled:"
console.log JSON.stringify template

outs = ''
gen.serialize template.data, -> outs += it

console.log "Final output: "
console.log outs

