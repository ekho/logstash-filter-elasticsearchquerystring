# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Esquerystring < LogStash::Filters::Base
  config_name "esquerystring"

  config :source, :validate => :array, :required => true
  config :target, :validate => :string, :required => true
  config :maxlength, :validate => :number, :default => 4096, :required => false
  config :length_autofix, :validate => :boolean, :default => false, :required => false

  public
  def register
    # Nothing to do
  end # def register

  public
  def filter(event)
    values = []

    @source.each do |field|
      next unless event.include?(field)
      value = event.get(field)
      next if value.nil?
      value = [value] unless value.is_a?(Array)
      next if value.length == 0
      values += value
    end

    return if values.length == 0
    values = values.uniq.map { |x| '"' + x + '"' }
    values_str = "(" + values.join(" OR ") + ")"
    if values_str.length > @maxlength
      msg = "Produced too long query string (>#{@maxlength}): #{values_str}"
      if @length_autofix
        while values_str.length > @maxlength
          values.pop
          values_str = "(" + values.join(" OR ") + ")"
        end
        @logger.warn(msg + "; Autofixed to: #{values_str}")
        event.set(@target, values_str)
      else
        @logger.error(msg)
      end
    else
      event.set(@target, values_str)
    end
  end # def filter

end # class LogStash::Filters::Esquerystring
