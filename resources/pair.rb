#
# Cookbook Name:: drbd
# Resource:: pair
#
actions :create

attribute :device, :regex => /\/dev\/drbd\d+/, :default => "/dev/drbd0"
attribute :disk, :kind_of => String, :required => true
attribute :res_name, :regex => /^[a-z][\w_]*$/, :name_attribute => true
# remote_host is for looking up its ip address, most likely FQDN
attribute :remote_host, :kind_of => String, :required => true

attribute :master, :equal_to => [true, false], :default => false
attribute :usage_count, :equal_to => ["no", "yes", "ask"], :default => "no"
attribute :protocol, :regex => /^[ABC]$/, :default => "C"

# TODO: make dynamic sync_rate possible
attribute :sync_rate, :kind_of => String, :default => "40M"

# If node['ipaddress'] is not what you want in resource config
attribute :local_ip, :kind_of => String
attribute :local_port, :kind_of => Integer, :default => 7789
attribute :remote_ip, :kind_of => String
attribute :remote_port, :kind_of => Integer, :default => 7789

def initialize(name, run_context=nil)
  super
  @action = :create
end
