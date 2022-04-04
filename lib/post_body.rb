# frozen_string_literal: true

module PostBody

  def self.render(source)
    Redcarpet::Markdown.new(
      Renderer.new,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      strikethrough: true,
    ).render(source)
  end

  class Renderer < Redcarpet::Render::HTML

    def block_code(code, language)
      lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

      # XXX HACK: Redcarpet strips hard tabs out of code blocks,
      # so we assume you're not using leading spaces that aren't tabs,
      # and just replace them here.
      if lexer.tag == "make"
        code.gsub!(/^    /, "\t")
      end

      formatter = rouge_formatter(
        wrap: false
      )

      compiled = formatter.format(lexer.lex(code))
      %{<pre class="">#{compiled}</pre>}
    end

    protected

    def rouge_formatter(opts = {})
      Rouge::Formatters::HTML.new(opts)
    end

  end

end
