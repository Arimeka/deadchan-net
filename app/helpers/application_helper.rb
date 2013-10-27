module ApplicationHelper
  def full_title(page_title)
    base_title = "Deadchan"
    if page_title.empty?
      APP['site_name']
    else
      "#{base_title} - #{page_title}"
    end
  end
end
