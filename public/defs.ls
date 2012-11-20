#need to be able to store my program
#so I don't keep losing it
#save key val
#load key val
#save and load
#are abstractions
#or can be redefined
#based on whatever the backend is
#for amazon s3 can use js3db
#or to start use openkeyval

#need to be able to add scripts from the web
#or download them and then add them



tag = (name, id, content) -> "<#{name} class=\"#{id}\">#{content}</#{name}>"
div = (classid, content) -> tag 'div', classid, content
$ \body .append (div 't1' 'test1')
make = (name, id, content) -> $ \body .append (tag name, id, content)
div = (id, content) -> make 'div', id, content
make 'p' 'par' 'This is a paragraph'
div 't3' 'test3'
$ \.t3 .draggable!
div 't4' 'test 4'
$ \.t4 .attr 'contentEditable' true

$.get "https://api.github.com/gists/" + gistid, dataType: "jsonp", (gistdata) ->
  objects = []
  for file of gistdata.data.files
    if gistdata.data.files[file]?
      o = JSON.parse gistdata.data.files[file].content
      if o? then objects.push o  
  console.log objects

