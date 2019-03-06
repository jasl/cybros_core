# frozen_string_literal: true

module ActionBarHelper
  def has_action_bar?
    content_for?(:action_bar)
  end

  def render_action_bar
    return unless has_action_bar?
    render "layouts/application/action_bar"
  end
end
