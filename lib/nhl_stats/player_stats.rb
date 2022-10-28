module NHLStats
  class PlayerStats
    # Due to changes in stats that are tracked, not all of these will be
    # populated, particularly for older stats sets
    #
    # PIM and Penalty Minutes are the same, one numeric the other a string, but I
    # suspect that they may not be present in all data sets so duplicating them
    # here anyways
    attr_reader :season, :time_on_ice, :assists, :goals, :pim, :shots, :games, :hits,
      :power_play_goals, :power_play_points, :power_play_time_on_ice, :even_time_on_ice,
      :penalty_minutes, :face_off_percent, :shot_percent, :game_winning_goals,
      :over_time_goals, :short_handed_goals, :short_handed_points,
      :short_handed_time_on_ice, :blocked_shots, :plus_minus, :points, :shifts,
      :time_on_ice_per_game, :even_time_on_ice_per_game,
      :short_handed_time_on_ice_per_game, :power_play_time_on_ice_per_game

    def initialize(player_stats_data)
      @season = player_stats_data["season"]
      simple_stats(player_stats_data["stat"])

      goal_stats(player_stats_data["stat"])
      points_stats(player_stats_data["stat"])

      percent_stats(player_stats_data["stat"])
      time_on_ice_stats(player_stats_data["stat"])
    end

    private

    def simple_stats(player_stats_data)
      @assists = player_stats_data.fetch("assists", nil)
      @pim = player_stats_data.fetch("pim", nil)
      @shots = player_stats_data.fetch("shots", nil)
      @games = player_stats_data.fetch("games", nil)
      @hits = player_stats_data.fetch("hits", nil)
      @penalty_minutes = player_stats_data.fetch("penaltyMinutes", nil)
      @blocked_shots = player_stats_data.fetch("blocked", nil)
      @plus_minus = player_stats_data.fetch("plusMinus", nil)
      @shifts = player_stats_data.fetch("shifts", nil)
    end

    def goal_stats(player_stats_data)
      @goals = player_stats_data.fetch("goals", nil)
      @power_play_goals = player_stats_data.fetch("powerPlayGoals", nil)
      @game_winning_goals = player_stats_data.fetch("gameWinningGoals", nil)
      @over_time_goals = player_stats_data.fetch("overTimeGoals", nil)
      @short_handed_goals = player_stats_data.fetch("shortHandedGoals", nil)
    end

    def points_stats(player_stats_data)
      @power_play_points = player_stats_data.fetch("powerPlayPoints", nil)
      @short_handed_points = player_stats_data.fetch("shortHandedPoints", nil)
      @points = player_stats_data.fetch("points", nil)
    end

    def percent_stats(player_stats_data)
      @face_off_percent = player_stats_data.fetch("faceOffPct", nil)
      @shot_percent = player_stats_data.fetch("shotPct", nil)
    end

    def time_on_ice_stats(player_stats_data)
      @time_on_ice = player_stats_data.fetch("timeOnIce", nil)
      @power_play_time_on_ice = player_stats_data.fetch("powerPlayTimeOnIce", nil)
      @even_time_on_ice = player_stats_data.fetch("evenTimeOnIce", nil)
      @short_handed_time_on_ice = player_stats_data.fetch("shortHandedTimeOnIce", nil)
      @time_on_ice_per_game = player_stats_data.fetch("timeOnIcePerGame", nil)
      @even_time_on_ice_per_game = player_stats_data.fetch("evenTimeOnIcePerGame", nil)
      @short_handed_time_on_ice_per_game = player_stats_data.fetch("shortHandedTimeOnIcePerGame", nil)
      @power_play_time_on_ice_per_game = player_stats_data.fetch("powerPlayTimeOnIcePerGame", nil)
    end
  end
end
