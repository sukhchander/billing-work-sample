module DashboardHelper

  def self.format_currency(amount)
    ActiveSupport::NumberHelper::number_to_currency(amount)
  end

  def self.format_unit(amount)
    ActiveSupport::NumberHelper::number_to_delimited(amount)
  end

  def self.determine_window
    start_date = 6.months.ago.beginning_of_day
    end_date = 1.day.ago.end_of_day
    start_date..end_date
  end

  def determine_window
    DashboardHelper.determine_window
  end

end