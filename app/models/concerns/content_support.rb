require 'markdown_renderer'

module ContentSupport
  extend ActiveSupport::Concern

  included do
    before_create :preprocess_content
  end

  def markdown(text)
    render_options = {
      hard_wrap: true,
      filter_html: false,
      link_attributes: {
        target: '_blank',
        rel: 'nofollow'
      },
      no_styles: true,
      no_images: true,
      escape_html: true
    }
    renderer = RenderWithoutHeaders.new(render_options)
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

  private
    def preprocess_content
      self.content = markdown(content)
    end
end