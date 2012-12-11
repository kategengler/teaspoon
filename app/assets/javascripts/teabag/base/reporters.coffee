#= require_self
#= require_tree ./reporters

class Teabag.Reporters.NormalizedSpec

  constructor: (@spec) ->
    @fullDescription = @spec.getFullName?() || @spec.fullTitle()
    @description ||= @spec.description || @spec.title
    @link = "?grep=#{encodeURIComponent(@fullDescription)}"


  errors: ->
    return [@spec.err] if @spec.err
    return [] unless @spec.results
    for item in @spec.results().getItems()
      continue if item.passed()
      {message: item.message, stack: item.trace.stack}


  result: ->
    status = "failed"
    if @spec.results
      results = @spec.results()
      status = "passed" if results.passed()
      skipped = results.skipped
    else
      status = "passed" if @spec.state == "passed"
      skipped = @spec.state == "skipped"
    status = "pending" if @spec.pending
    {
      status: status
      skipped: skipped
    }


class Teabag.Reporters.BaseView

  constructor: ->
    @build()


  build: (className) ->
    @el = @createEl("li", className)


  appendTo: (el) ->
    el.appendChild(@el)


  append: (el) ->
    @el.appendChild(el)


  createEl: (type, className = "") ->
    el = document.createElement(type)
    el.className = className
    el


  findEl: (id) ->
    @elements ||= []
    @elements[id] ||= document.getElementById("teabag-#{id}")


  setText: (id, value) ->
    el = @findEl(id)
    el.innerText = value


  setHtml: (id, value, add = false) ->
    el = @findEl(id)
    if add then el.innerHTML += value else el.innerHTML = value


  setClass: (id, value) ->
    el = @findEl(id)
    el.className = value
