# Other helpers
module ApplicationHelper
  def markdown(text)
    md_options = { autolink: true, no_intra_emphasis: true,
                   fenced_code_blocks: true, superscript: true,
                   highlight: true, quote: true }
    renderer_options = { hard_wrap: true, filter_html: true }

    highlight_syntax Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(renderer_options), md_options
    ).render(text)
  end

  def highlight_syntax(html)
    doc = Nokogiri::HTML.fragment html
    doc.search('code[@class]').each do |code|
      code.replace Pygmentize.process(code.text.rstrip, code[:class])
    end
    doc.to_s.html_safe
  end

  def get_number(quiz, question)
    Relationship.find_by(question_id: question, quiz_id: quiz).number
  end
end
