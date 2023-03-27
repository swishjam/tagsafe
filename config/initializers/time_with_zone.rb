module ActiveSupport
  class TimeWithZone
    def date_only(short: true)
      short ? strftime('%m/%d/%y') : strftime('%A, %B %d')
    end

    def time_only
      strftime('%I:%M %p (%Z)')
    end

    def formatted
      # strftime("%A, %B %d @ %I:%M %p (%Z)")
      "#{date_only(short: false)} @ #{time_only}"
    end
    alias formatted_long formatted

    def formatted_short
      # strftime("%m/%d/%y @ %l:%M %P %Z")
      "#{date_only} @ #{time_only}"
    end
  end
end