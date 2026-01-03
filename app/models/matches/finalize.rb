module Matches
  class Finalize
    attr_reader :match, :params, :errors

    def initialize(match, params)
      @match = match
      @params = params
      @errors = []
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do
        update_match!
        update_results!
        sync_achievements!
        recalculate_scores!
      end

      true
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
      false
    end

    private

    def valid?
      return true if winner_id.blank?

      unless match_participant_ids.include?(winner_id)
        @errors << I18n.t("matches.update.invalid_winner")
        return false
      end

      true
    end

    def update_match!
      match.update!(duration: params[:duration], winner_id: winner_id)
    end

    def update_results!
      params[:match_results]&.each do |result_data|
        result = match.match_results.find_by(id: result_data[:id])
        next unless result

        total_score = calculate_score(result, result_data[:position])
        result.update!(position: result_data[:position], score: total_score)
      end
    end

    def sync_achievements!
      match.match_achievements.destroy_all

      params[:match_achievements]&.each do |achievement_data|
        user_id = achievement_data[:user_id].to_i
        achievement_id = achievement_data[:tournament_achievement_id].to_i

        next unless match_participant_ids.include?(user_id)
        next unless valid_achievement_ids.include?(achievement_id)

        match.match_achievements.create!(user_id: user_id, tournament_achievement_id: achievement_id)
      end
    end

    def recalculate_scores!
      tournament.recalculate_participant_scores!
    end

    def calculate_score(result, position)
      position_points = tournament.scoring_for_position(position)
      achievement_points = calculate_achievement_points(result.user_id)
      position_points + achievement_points
    end

    def calculate_achievement_points(user_id)
      user_achievements = params[:match_achievements]&.select { |ma| ma[:user_id] == user_id } || []

      user_achievements.sum do |ua|
        tournament.tournament_achievements.find_by(id: ua[:tournament_achievement_id])&.points || 0
      end
    end

    def tournament
      @tournament ||= match.tournament
    end

    def winner_id
      @winner_id ||= params[:winner_id].presence&.to_i
    end

    def match_participant_ids
      @match_participant_ids ||= match.match_results.pluck(:user_id)
    end

    def valid_achievement_ids
      @valid_achievement_ids ||= tournament.tournament_achievements.pluck(:id)
    end
  end
end
