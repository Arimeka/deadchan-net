DeadchanNetBackend.Views.Dashboard ||= {}

class DeadchanNetBackend.Views.Dashboard.Show extends Backbone.View
  el: '#dashboard'

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
