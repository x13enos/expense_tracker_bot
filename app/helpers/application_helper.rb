module ApplicationHelper
  def active_navigation_link?(name)
    controller.controller_name == name
  end
end
