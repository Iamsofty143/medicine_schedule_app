module ScheduleEmailNotificationConcern
  extend ActiveSupport::Concern

  def schedule_notification(task, scheduled_date)
    sorted_date_times = if task.frequency == 'custom'
                        get_today_schedule(task.schedule)
                      else
                        task.schedule.values
                      end

    next_schedule, scheduled_datetime = calculate_schedule(task, scheduled_date, sorted_date_times.flatten.sort)
    { next_schedule: next_schedule, time_difference: scheduled_datetime } 
  end

  private

  def calculate_schedule(task, scheduled_date, sorted_date_times)
    if ['daily', 'weekly', 'life_long'].include?(task.frequency) && task.end_date >= Date.today
      calculate_daily_weekly_schedule(task, scheduled_date, sorted_date_times)
    else 
      [false, nil]
    end
  end

  def calculate_daily_weekly_schedule(task, scheduled_date, sorted_date_times)
    next_schedule = true
    upcoming_time = if scheduled_date == Date.today
                        sorted_date_times.find { |dt| Time.parse(dt).strftime("%H:%M:%S") > (Time.now).strftime("%H:%M:%S")}
                      else
                        sorted_date_times.first
                      end

    if upcoming_time.nil?
      if task.end_date == Date.today
        next_schedule = false
        return [next_schedule, nil]
      end 
      scheduled_date += (task.frequency == 'daily' ? 1.day : 1.week)
      upcoming_time = sorted_date_times.first
    end

    scheduled_time = DateTime.parse(upcoming_time.to_s)
    scheduled_datetime = DateTime.new(scheduled_date.year, scheduled_date.month, scheduled_date.day, scheduled_time.hour, scheduled_time.minute, scheduled_time.second, scheduled_time.zone).to_s
    [next_schedule, scheduled_datetime]
  end

  def get_today_schedule(schedule)
    # Get today's weekday
    today_weekday = Date.today.strftime("%A").downcase
    
    # Check if today's weekday exists in the schedule
    if schedule.key?(today_weekday)
      return schedule[today_weekday]
    else
      return []
    end
  end
end

