fs = require 'fs'

S4 = () ->
   (((1+Math.random())*0x10000)|0).toString(16).substring(1)

guid = () ->
   S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4()

saving = {}

toSave = {}

delay = (ms, func) -> setTimeout func, ms

fname = (id) ->
  console.log 'id is ' + id
  console.log 'fname (id) is ' + __dirname + '/data/' + id + '.json'
  return __dirname + '/data/' + id + '.json'

get = (id, callback) ->  
  if toSave[id]?
    callback toSave[id]
  else
    fs.exists fname(id), (exists) ->
      if not exists
        callback ''
      else
        fs.readFile fname(id), (err, str) ->
          if err?
            console.log 'Error reading data:'
            console.log err
          else
            callback JSON.parse(str)  

save = (id) ->
  fs.writeFile fname(id), JSON.stringify(toSave[id]), (err) ->
    if err?
      console.log 'Error saving data:'
      console.log err    
    delete saving[id]

update = (id, data) ->
  toSave[id] = data
  if not saving[id]?
    saving[id] = true
    delay 15000, ->    
      save id

exports.update = update
exports.get = get
exports.guid = guid
