class ApplicationController < ActionController::Base
  include Authentication
  helper InertiaRails::Helper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  inertia_share auth: -> {
    {
      user: Current.user&.as_json(only: [ :id, :email_address, :nickname ])
    }
  }

  inertia_share flash: -> {
    flash.to_hash
  }
end
