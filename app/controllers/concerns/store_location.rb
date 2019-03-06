# frozen_string_literal: true

require "uri"

# Provide the ability to store a location.
# Used to redirect back to a desired path after sign in.
# Included by default in all controllers.
module StoreLocation
  extend ActiveSupport::Concern

  included do
    helper_method :stored_location?, :stored_location
  end

  # Returns and delete (if it's navigational format) the url stored in the session for
  # the given scope. Useful for giving redirect backs after sign up:
  #
  # Example:
  #
  #   redirect_to stored_location || root_path
  #
  def stored_location(scope: nil)
    session_key = stored_location_key(scope)

    if is_navigational_format?
      session.delete(session_key)
    else
      session[session_key]
    end
  end

  def stored_location?(scope: nil)
    session_key = stored_location_key(scope)
    session[session_key].present?
  end

  # Stores the provided location to redirect the user after signing in.
  # Useful in combination with the `stored_location_for` helper.
  #
  # Example:
  #
  #   store_location_for(dashboard_path)
  #   redirect_to user_facebook_omniauth_authorize_path
  #
  def store_location(location, scope: nil)
    session_key = stored_location_key(scope)
    uri = parse_uri(location)
    if uri
      path = [uri.path.sub(/\A\/+/, "/"), uri.query].compact.join("?")
      path = [path, uri.fragment].compact.join("#")
      session[session_key] = path
    end
  end

  private

    def parse_uri(location)
      location && URI.parse(location)
    rescue URI::InvalidURIError
      nil
    end

    def stored_location_key(scope = nil)
      if scope.blank?
        "return_to"
      else
        "#{scope}_return_to"
      end
    end
end
