require 'markdown_renderer'

module ContentSupport
  extend ActiveSupport::Concern

  included do
    before_create :preprocess_content, unless: 'lodge'
    after_create  :find_replies
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

    def find_replies
      str = self.content
      replies = str.scan(/\+(\w+(#\w+)?)/)
      replies.uniq.take(10).each do |repl|
        r = repl.first
        a = r.split('#')
        if a.size == 1
          if self.kind_of? Tread
            tread = self
          elsif self.kind_of? Post
            tread = self.tread
          end

          if tread
            post = tread.posts.where(id: r).first
            if post
              if post.replies
                arr = post.replies.map { |a| a['post_id'] }
                unless (arr & [self.id]) == arr
                  if self.kind_of? Post
                    post.replies << {board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}
                  else
                    post.replies << {board_abbr: self.board.abbr, tread_id: self.id}
                  end
                  post.save
                end
              else
                if self.kind_of? Post
                  post.replies = [{board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}]
                else
                  post.replies = [{board_abbr: self.board.abbr, tread_id: self.id}]
                end
                post.save
              end

              str.gsub!("+#{r}","<a class='parent-post' href='/#{tread.board.abbr}/#{tread.id}##{r}'><strong>+#{tread.id.to_s.last(7)}##{r.last(7)}</strong></a>")
            else
              another_tread = Tread.where(id: r).first
              if another_tread
                if another_tread.replies
                  arr = another_tread.replies.map { |a| a['post_id'] }
                  unless (arr & [self.id]) == arr
                    if self.kind_of? Post
                      another_tread.replies << {board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}
                    else
                      another_tread.replies << {board_abbr: self.board.abbr, tread_id: self.id}
                    end
                    another_tread.save
                  end
                else
                  if self.kind_of? Post
                    another_tread.replies = [{board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}]
                  else
                    another_tread.replies = [{board_abbr: self.board.abbr, tread_id: self.id}]
                  end
                  another_tread.save
                end
                str.gsub!("+#{r}","<a class='parent-post' href='/#{tread.board.abbr}/#{tread.id}'><strong>+#{r.last(7)}</strong></a>")
              end
            end
          end
        elsif a.size == 2
          tread = Tread.where(id: a.first).first
          if tread && (post = tread.posts.where(id: a.last).first)
            if post.replies
              arr = another_tread.replies.map { |a| a['post_id'] }
              unless (arr & [self.id]) == arr
                post.replies << {board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}
                post.save
              end
            else
              post.replies = [{board_abbr: self.tread.board.abbr, tread_id: self.tread.id, post_id: self.id}]
              post.save
            end
            post.save
            str.gsub!("+#{r}","<a href='/#{tread.board.abbr}/#{tread.id}##{post.id}'><strong>+#{tread.id.to_s.last(7)}##{post.id.to_s.last(7)}</strong></a>")
          end
        end
      end

      self.content = str
      self.save
    end
end
