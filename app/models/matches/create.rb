module Matches
  class Create
    attr_reader :tournament, :params, :match, :errors

    def initialize(tournament, params)
      @tournament = tournament
      @params = params
      @errors = []
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do
        create_match!
        create_results!
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
      false
    end

    def valid?
      if player_ids.empty?
        @errors << I18n.t("matches.create.no_players")
        return false
      end

      if valid_player_ids.empty?
        @errors << I18n.t("matches.create.invalid_players")
        return false
      end

      true
    end

    private

    def create_match!
      @match = tournament.matches.create!(
        created_by: Current.user,
        played_at: played_at,
        duration: duration,
        round: tournament.matches.count + 1
      )
    end

    def create_results!
      valid_player_ids.each do |user_id|
        match.match_results.create!(user_id: user_id, tournament: tournament)
      end
    end

    def past_match?
      params[:match_type] == "past"
    end

    def played_at
      return Time.current unless past_match? && params[:started_at].present?

      Time.zone.parse(params[:started_at])
    end

    def duration
      return nil unless past_match?
      return nil if params[:started_at].blank? || params[:ended_at].blank?

      started = Time.zone.parse(params[:started_at])
      ended = Time.zone.parse(params[:ended_at])

      ended > started ? (ended - started).to_i : nil
    end

    def player_ids
      @player_ids ||= Array(params[:player_ids]).map(&:to_i)
    end

    def valid_player_ids
      @valid_player_ids ||= player_ids & tournament.users.pluck(:id)
    end
  end
end
