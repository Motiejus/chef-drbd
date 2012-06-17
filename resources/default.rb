#
# Cookbook Name:: drbd
# Resource:: default
#
actions :setup

attribute :usage_count, :equal_to => ["no", "yes", "ask"], :default => "no"
attribute :protocol, :regex => /^[ABC]$/, :default => "C"
# TODO: make dynamic sync_rate possible
attribute :sync_rate, :kind_of => String, :default => "40M"


def initialize(name, run_context=nil)
  super
  @action = :setup
end
