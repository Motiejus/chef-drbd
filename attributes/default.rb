default[:drbd][:resource] = nil
default[:drbd][:internal_ip] = nil
default[:drbd][:remote_ip] = nil
default[:drbd][:remote_host] = nil
default[:drbd][:disk] = nil
default[:drbd][:mount] = nil
default[:drbd][:fs_type] = "ext3"
default[:drbd][:dev] = "/dev/drbd0"
default[:drbd][:master] = false
default[:drbd][:port] = 7789
default[:drbd][:usage_count] = "yes"
default[:drbd][:protocol] = "C"
default[:drbd][:sync_rate] = "40M"
default[:drbd][:configured] = false