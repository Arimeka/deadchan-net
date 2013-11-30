class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:boards) { Board.published }

  private
    def markdown(text)
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false)
      options = {
          autolink: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          lax_html_blocks: true,
          strikethrough: true,
          superscript: true,
          space_after_headers: true
      }
      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
end
