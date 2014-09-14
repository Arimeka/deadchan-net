require 'paginate_link_renderer'

module ApplicationHelper
  def full_title(page_title)
    base_title = "Deadchan"
    if page_title.empty?
      Settings.site_name
    else
      "#{base_title} - #{page_title}"
    end
  end

  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => PaginateLinkRenderer
    end
    super *[collection_or_options, options].compact
  end

  def bootstrap_class_for(type)
    case type.to_sym
    when :success
      'success'
    when :error
      'danger'
    when :alert
      'warning'
    when :notice
      'info'
    else
      'danger'
    end
  end

  def breadcrumbs(entry = nil)
    base_title = "Deadchan"
    root = link_to base_title, root_path
    unless entry
      Settings.site_name
    else
      case entry.class.name
      when 'Board'
        "#{root} - #{link_to entry.title, board_path(entry.abbr)}".html_safe
      when 'Tread'
        "#{root} - #{link_to entry.board.title, board_path(entry.board.abbr)} - #{link_to entry.title, tread_path(entry.board.abbr, entry.id)}".html_safe
      end
    end
  end
end
