module ApplicationHelper
  def page_header(title)
    render partial: 'shared/login_page_header', locals: {title: title}
  end
end
