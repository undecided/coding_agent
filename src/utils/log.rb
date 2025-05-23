# frozen_string_literal: true

# Log utility with colored output for different log levels
module Log
  HEADER = "\e[95m"
  BLUE = "\e[94m"
  CYAN = "\e[96m"
  GREEN = "\e[92m"
  ORANGE = "\e[93m"
  RED = "\e[91m"
  ENDC = "\e[0m"
  BOLD = "\e[1m"
  UNDERLINE = "\e[4m"

  def self.red(message) ; "#{RED}#{message}#{ENDC}" ; end
  def self.green(message) ; "#{GREEN}#{message}#{ENDC}" ; end
  def self.orange(message) ; "#{ORANGE}#{message}#{ENDC}" ; end
  def self.blue(message) ; "#{BLUE}#{message}#{ENDC}" ; end
  def self.cyan(message) ; "#{CYAN}#{message}#{ENDC}" ; end

  def self.line(*segments, &block)
    segments.map { |s| self << s.to_s }.join(" ")
    yield self if block_given?
    newline
  end

  def self.<<(message)
    @buffer ||= []
    @buffer << message
    self
  end

  def self.newline
    $stderr.puts @buffer.join(" ")
    @buffer.clear
    self
  end

  def self.info(message)
    line blue("[INFO]"), message
  end

  def self.success(message)
    line green("[SUCCESS]"), message
  end

  def self.warning(message)
    line orange("[WARNING]"), message
  end

  def self.error(message)
    line red("[ERROR]"), message
  end
end
