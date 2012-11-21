traverse = require \traverse

fill = (template, data) ->
  fill = data.site{title:name, content:page}
  traverse template .forEach (val) -> 
    return unless @isLeaf
    if val.indexOf('{{') >= 0
      key = val.substr 2 val.length-4
      @update fill[key]

open = -> "<#{it}>\n"
close = -> "</#{it}>\n"

serialize = !(data, outputfunc) ->
  outputfunc '<!DOCTYPE html>\n'
  traverse data .forEach (obj) ->
    return unless obj?
    spcs = [' ' for til @level] .join ''
    if typeof obj is 'string'
      outputfunc spcs + obj      
      return obj
    return unless typeof obj is 'object'
    return if obj.length?
    try
      for prop, v of obj 
        @before ->
          outputfunc \\n + spcs + open prop
        @after -> 
          outputfunc \\n + spcs + close prop
    catch
      console.log e    
    undefined

export fill, serialize

