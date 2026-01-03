class ApplicationController < ActionController::Base
  include Authentication
  helper InertiaRails::Helper

  allow_browser versions: :modern

  inertia_share auth: -> { { user: current_user_data } }
  inertia_share flash: -> { flash.to_hash }
  inertia_share organized_tournaments: -> { organized_tournaments_data }

  private

  def current_user_data
    Current.user&.as_json(only: %i[uuid nickname avatar_url])
  end

  def organized_tournaments_data
    Current.user&.organized_tournaments&.select(:id, :name, :slug)&.order(created_at: :desc) || []
  end
end
