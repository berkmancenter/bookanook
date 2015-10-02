module ApplicationHelper
  def active_page?(page)
    params[:controller] == page
  end

  def alert_class(flash_name)
    return 'alert-danger' if flash_name == 'alert'
    return 'alert-success' if flash_name == 'notice'
    return 'alert-info' if flash_name == 'flash'
  end
end
