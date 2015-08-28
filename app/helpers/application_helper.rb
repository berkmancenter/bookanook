module ApplicationHelper
  def active_page?(page)
    params[:controller] == page
  end
end
