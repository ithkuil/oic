traverse = require \traverse

exports.fill = (template, data) ->
  fill =
    title: data.site.name
    content: data.site.page

  traverse template .forEach (val) -> 
    if not @isLeaf then return
    if val.indexOf('{{') >= 0
      key = val.substr 2, val.length-4
      @update fill[key]

open = (name) -> "<#{name}>\n"
close = (name) -> "</#{name}>\n"

exports.serialize = (data, outputfunc) ->
  outputfunc '<!DOCTYPE html>\n'
  traverse data .forEach (obj) ->
    if not obj? then return
    spcs = [' ' for til @level] .join ''
    if typeof obj is 'string'
      outputfunc spcs + obj      
      return obj
    if not typeof obj is 'object' then return    
    if obj.length? then return
    try
      for prop, v of obj 
        @before ->
          outputfunc \\n + spcs + open prop
        @after -> 
          outputfunc \\n + spcs + close prop
    catch e
      console.log e
    undefined


