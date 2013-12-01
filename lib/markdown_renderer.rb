class RenderWithoutHeaders < Redcarpet::Render::HTML
  def header(text, header_level)
    text
  end
end