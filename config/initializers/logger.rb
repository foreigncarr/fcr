Rails.class_eval do
  class << self
    alias_method :logger_default, :logger

    def logger(arg=nil)
      case arg
        when :operation
          logger_default
        when :stat
          @stat_logger ||= begin
            stat_logger = Logger.new("#{Rails.root.to_s}/log/stat_report.log")
            stat_logger.formatter = ActiveSupport::Logger::NonFormatter.new
            stat_logger
          end
        else
          logger_default
      end
    end
  end
end


class ActiveSupport::Logger::SimpleFormatter
  SEVERITY_TO_TAG_MAP     = {'DEBUG'=>'meh', 'INFO'=>'fyi', 'WARN'=>'hmm', 'ERROR'=>'wtf', 'FATAL'=>'omg', 'UNKNOWN'=>'???'}
  SEVERITY_TO_COLOR_MAP   = {'DEBUG'=>'0;37', 'INFO'=>'32', 'WARN'=>'33', 'ERROR'=>'31', 'FATAL'=>'31', 'UNKNOWN'=>'37'}
  USE_HUMOROUS_SEVERITIES = true

  def call(severity, time, progname, msg)
    formatted_severity = sprintf("%-5s","#{severity}")
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    color = SEVERITY_TO_COLOR_MAP[severity]
    "\033[0;37m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] #{msg.strip}\n"
  end
end

class ActiveSupport::Logger::NonFormatter
  def call(severity, time, progname, msg)
    "#{msg}\n"
  end
end