gen = require './htmlgen'
fs = require \fs

export generate = (template, datafile, outfile) ->
  template = require "./#{template}"
  console.log 'datafile is ' + datafile
  data = require "./#{datafile}" .data
 
  gen.fill template, data

  outs = ''
  gen.serialize template.data, -> outs += it
  fs.writeFile outfile, outs, 'utf-8'
