DeadchanNetBackend.Views.Threads ||= {}

class DeadchanNetBackend.Views.Threads.Show extends Backbone.View
  el: '#thread'

  events:
    'click .pagination li a': 'loadPosts'
    'click .js-post-checked': 'toggleStatus'
    'click .js-post-published': 'toggleStatus'

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

  toggleStatus: (e) ->
    $target = $(e.currentTarget)
    $form = $target.parent('form')
    $container = $target.closest('tr')
    href = $form.attr('action')

    checked = $container.find('.js-post-checked').prop('checked')
    published = $container.find('.js-post-published').prop('checked')

    $.ajax
      url: href
      type: 'PUT'
      dataType: 'html'
      data:
        post: {is_checked: checked, is_published: published}
      success: ->
        $container.removeClass()
        if published == false
          $container.addClass('bg-danger')
        else if checked == false
          $container.addClass('bg-warning')
        else
          $container.addClass('bg-success')
