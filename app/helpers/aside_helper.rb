# frozen_string_literal: true

module AsideHelper
  def has_aside?
    content_for?(:aside)
  end

  def render_aside
    return unless has_aside?
    render "layouts/application/aside_menu"
  end
end
