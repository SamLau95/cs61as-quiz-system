# Other helpers
module ApplicationHelper
  def markdown(text)
    md_options = { autolink: true, no_intra_emphasis: true,
                   fenced_code_blocks: true, superscript: true,
                   underline: true, highlight: true, quote: true }
    renderer_options = { hard_wrap: true, filter_html: true }
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(renderer_options), md_options
    ).render(text).html_safe
  end
end
