module ApplicationHelper
  BASE_TITLE = "rkeep"

  def full_title(page_title = '')
    return "#{page_title} | #{BASE_TITLE}" unless page_title.empty?
    BASE_TITLE
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
end
