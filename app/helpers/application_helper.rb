module ApplicationHelper
  def page_header(title)
    render partial: 'shared/login_page_header', locals: {title: title}
  end

  def render_flash(type)
    render partial: 'shared/flash', locals: {type: type} if flash[type]
  end
end
