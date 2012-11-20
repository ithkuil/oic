process.html = {}
process.getgen = -> process.html

if process? then main = process else main = window

html = main.getgen 'html'

{tag, page, h1, pages} = main.getfuncs 'html', 'tag page h1 pages'

tag = (name) -> console.log name

console.log process.html

#html.tag = (name) -> html.write "<{#name}></#{name}"

#html.page = (name, p) -> html.div name, htmlgen.gen p 

#html.h1 = (obj, data) -> html.tag 'h1' 

#html.pages = (obj) -> 
#  html.page name, p for name, p of obj.node
  


