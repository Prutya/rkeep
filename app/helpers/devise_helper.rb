module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| "toastr.error(\"#{msg}\", \"Error\");" }

    script = <<-HTML
    <script>$(document).ready(function(){ #{messages.join} });</script>
    HTML

    script.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
  
end
