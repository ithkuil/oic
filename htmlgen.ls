traverse = require \traverse

fill = (template, data) ->
  vals = data.site{title:name, content:page}
  traverse template .forEach -> 
    | not @isLeaf                     => undefined
    | it.indexOf('{{') >= 0           => @update vals[it.substr 2 it.length-4]

open = -> "<#{it}>\n"
close = -> "</#{it}>\n"

spaces = -> [' ' for til it] .join ''

serialize = (data, outputfunc) ->
  outputfunc '<!DOCTYPE html>\n'
  traverse data .forEach !->    
    | not it?                   => undefined
    | typeof it is 'string'     => outputfunc (spaces @level) + it
    | typeof it isnt 'object'   => undefined
    | it.length?                => undefined
    | otherwise                 =>
      try
        for prop, v of it 
          @before -> outputfunc \\n + (spaces @level) + open prop
          @after  -> outputfunc \\n + (spaces @level) + close prop
      catch
        console.log e    


export fill, serialize

