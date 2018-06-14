require 'time'
require_relative 'couple'

class MinHour
  attr_accessor :hour, :min, :sec

  def initialize(time)
    @hour = Time.parse(time).hour
    @min = Time.parse(time).min
    @sec = Time.parse(time).sec
  end

  def total_seconds_from_start_of_day
    (@hour * 60 * 60) + (@min * 60) + @sec
  end

  def diff_in_secs(another_time)
    max(another_time.total_seconds_from_start_of_day - total_seconds_from_start_of_day, 0)
  end

  def <=>(another_obj)
    total_seconds_from_start_of_day - another_obj.total_seconds_from_start_of_day
  end

  def <(another_obj)
    total_seconds_from_start_of_day - another_obj.total_seconds_from_start_of_day < 0
  end

  def >(another_obj)
    total_seconds_from_start_of_day - another_obj.total_seconds_from_start_of_day > 0
  end

  def to_s
    "#{@hour} - #{@min} - #{sec}"
  end
end

def min(a, b)
  a < b ? a : b
end

def max(a, b)
  a > b ? a : b
end

class BusinessHours
  def initialize(start_time, end_time)
    @start_time = MinHour.new(start_time)
    @end_time = MinHour.new(end_time)
    @closed_dates = {}
    @custom_dates = {}
  end

  def update(day, start_time, end_time)
    @closed_dates.delete(get_key(day))
    @custom_dates[get_key(day)] = Couple.new(MinHour.new(start_time), MinHour.new(end_time))
  end

  def calculate_deadline(time_needed, date_given)
    date = Time.parse(date_given)
    start_time = max(MinHour.new(date_given), @start_time)
    date -= MinHour.new(date_given).total_seconds_from_start_of_day

    while time_needed > 0
      available_seconds = get_open_seconds_for_day(date, start_time)
      if available_seconds >= time_needed
        return (date + @start_time.total_seconds_from_start_of_day + time_needed).strftime('%A %b %d %H:%M:%S %Y')
      else
        time_needed -= available_seconds
        start_time = @start_time
      end
      date += 24 * 60 * 60
    end
  end

  def get_open_seconds_for_day(day, start_time = @start_time, end_time = @end_time)
    if @closed_dates.key?(day.to_s.to_sym) || @closed_dates.key?(get_day_symbol(day))
      0
    elsif @custom_dates.key?(day.to_s.to_sym)
      max(@custom_dates[day.to_s.to_sym].one, start_time).diff_in_secs(min(@custom_dates[day.to_s.to_sym].two, end_time))
    else
      start_time.diff_in_secs(end_time)
    end
  end

  def get_day_symbol(day)
    day.strftime('%A').downcase[0, 3].to_sym
  end

  def get_key(day)
    day.is_a?(Symbol) ? day : Time.parse(day).to_s.to_sym
  end

  def closed(*args)
    args.each do |day|
      day = get_key(day)
      @custom_dates.delete(day)
      @closed_dates[day] = true
    end
  end
end

# Case 1
hours = BusinessHours.new('9:00 AM', '3:00 PM')
hours.update(:fri, '10:00 AM', '5:00 PM')
hours.update('Dec 24, 2010', '8:00 AM', '1:00 PM')
hours.closed(:sun, :wed, 'Dec 25, 2010')

puts hours.calculate_deadline(2 * 60 * 60, 'Jun 7, 2010 9:10 AM') # => Mon Jun 07 11:10:00 2010
puts hours.calculate_deadline(15 * 60, 'Jun 8, 2010 2:48 PM') # => Thu Jun 10 09:03:00 2010
puts hours.calculate_deadline(7 * 60 * 60, 'Dec 24, 2010 6:45 AM') # => Mon Dec 27 11:00:00 2010
