DeadchanNetBackend.Views.Threads ||= {}

class DeadchanNetBackend.Views.Threads.Show extends Backbone.View
  el: '#thread'

  events:
    'click .pagination li a': 'loadPosts'

  initialize: ->
    @loadCharts()

  loadCharts: ->
    pathname = window.location.pathname
    $.ajax
      url: pathname + '/statistics'
      dataType: 'json'
      success: (data) ->
        if data?
          if data.posting?
            new Morris.Line({
              element: 'js-morris-area-posts-count'
              data: data.posting
              xkey: 'time'
              ykeys: ['count']
              labels: ['Постов']
              parseTime: false
              hideHover: 'auto'
              resize: true
            })
          if data.visits?
            new Morris.Line({
              element: 'js-morris-area-views-count'
              data: data.visits
              xkey: 'time'
              ykeys: ['views', 'uniq']
              labels: ['Просмотров', 'Уникальных']
              parseTime: false
              hideHover: 'auto'
              resize: true
            })

  loadPosts: (e) ->
    e.preventDefault()
    $button = $(e.currentTarget)
    activity = $button.parent('li').hasClass('active')
    $container = @$('#posts')
    $spinner = $('.loading')
    href = $button.attr('href')

    unless activity
      $.ajax
        url: href
        dataType: 'html'
        beforeSend: ->
          $spinner.show()
        success: (data) ->
          $container.html data
        complete: ->
          $spinner.hide()
