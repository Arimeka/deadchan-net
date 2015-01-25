#= require raphael/raphael-min
#= require morrisjs/morris.min

$ ->
  $(document).ready ->
    if $('#js-board-statistics').length
      pathname = window.location.pathname
      $.ajax
        url: pathname + '/statistics'
        type: 'GET'
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
