# frozen_string_literal: true

module SidebarHelper
  def collapsed_sidebar?
    cookies["sidebar_collapsed"] == "true"
  end

  def use_sidebar(name = "application")
    @_sidebar_name = name
  end

  def has_sidebar?
    @_sidebar_name.present?
  end

  def render_sidebar
    return unless has_sidebar?
    render "layouts/sidebars/#{@_sidebar_name}"
  end
end
