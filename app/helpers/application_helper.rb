module ApplicationHelper
  DEFAULT_TITLE = "rkeep"

  def full_title(page_title = '')
    title = Configuration.last_set.company_name || DEFAULT_TITLE
    return "#{page_title} | #{title}" unless page_title.empty?
    title
  end

  def toastr_flash
    return "" if flash.empty?

    toasts = flash.map do |key, value|
      action = key.to_s.gsub(/alert|error/, 'error').gsub('notice', 'success')
      "toastr.#{action}(\"#{value}\", \"#{action.capitalize}\");"
    end

    script = <<-HTML
    <script>$(document).ready(function(){ #{toasts.join} });</script>
    HTML

    script.html_safe
  end

  def breadcrumbs(items, options = nil)
    content_tag(:nav, nil, class: "breadcrumbs #{options[:class] if options}") do
      items.map { |item|
        unless item[:link]
          content_tag(:span, item[:text], class: "breadcrumbs-item active #{item[:class]}")
        else
          link_to item[:text], item[:link], class: "breadcrumbs-item"
        end
      }.join.html_safe
    end
  end

  def crumb(text, link = nil, active = false, options = nil)
    { text: text, link: link, class: "#{options[:class] if options}" }
  end
end
