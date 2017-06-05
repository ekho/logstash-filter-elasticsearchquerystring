# encoding: utf-8

require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/esquerystring"

describe LogStash::Filters::Esquerystring do

  describe "esquerystring with single value" do
    # The logstash config goes here.
    # At this time, only filters are supported.
    config <<-CONFIG
      filter {
        esquerystring {
          source => "src"
          target => "dst"
        }
      }
    CONFIG

    sample("src" => "arg1") do
      insist { subject.get("dst") } == "arg1"
    end
  end

  describe "esquerystring string with array" do
    config <<-CONFIG
      filter {
        esquerystring {
          source => "src"
          target => "dst"
        }
      }
    CONFIG

    sample("src" => ["arg1", "arg2"]) do
      insist { subject.get("dst") } == "(arg1 OR arg2)"
    end
  end

  describe "esquerystring string with non unique array" do
    config <<-CONFIG
      filter {
        esquerystring {
          source => "src"
          target => "dst"
        }
      }
    CONFIG

    sample("src" => ["arg1", "arg2", "arg2", "arg3"]) do
      insist { subject.get("dst") } == "(arg1 OR arg2 OR arg3)"
    end
  end

end
