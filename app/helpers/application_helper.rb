module ApplicationHelper
  def rank_to_color(elo)
    return "table-info" if elo >= 2400.0
    return "table-primary" if elo >= 2200.0
    return "table-success" if elo >= 2000.0
    return "table-warning" if elo >= 1800.0
    return "table-warning" if elo >= 1600.0
    return "table-active" if elo >= 1400.0
    return "table-active" if elo >= 1200.0
    return "table-active" if elo >= 1000.0
    return "table-default"
  end
end
