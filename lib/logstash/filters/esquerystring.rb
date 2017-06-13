# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Esquerystring < LogStash::Filters::Base
  config_name "esquerystring"

  config :source, :validate => :array, :required => true
  config :target, :validate => :string, :required => true

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
    values = "(" + values.uniq.map { |x| '"' + x + '"' }.join(" OR ") + ")"
    event.set(@target, values)
  end # def filter

end # class LogStash::Filters::Esquerystring
