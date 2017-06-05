# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Esquerystring < LogStash::Filters::Base
  config_name "esquerystring"

  config :source, :validate => :string, :required => true
  config :target, :validate => :string, :required => true

  public
  def register
    # Nothing to do
  end # def register

  public
  def filter(event)
    return unless event.include?(@source)

    value = event.get(@source)
    if value.is_a?(Array)
      value = "(" + value.uniq.join(" OR ") + ")"
    end

    event.set(@target, value)
  end # def filter

end # class LogStash::Filters::Esquerystring
