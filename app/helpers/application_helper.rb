module ApplicationHelper
  BASE_TITLE = "rkeep"

  def full_title(page_title = '')
    return "#{page_title} | #{BASE_TITLE}" unless page_title.empty?
    BASE_TITLE
  end
end
