require 'chef/shell_out'

action :create do
    rhost = new_resource.remote_host
    remote = search(:node, "name:#{rhost}")[0]
    remote_ip = new_resource.remote_ip || remote.ipaddress
    local_ip = new_resource.local_ip || node.ipaddress

    template "/etc/drbd.d/#{resource}.res" do
        source "res.erb"
        variables(
            :device => new_resource.device,
            :disk => new_resource.disk,
            :resource => new_resource.res_name,
            :remote_host => new_resource.remote_host,

            :local_ip => local_ip,
            :remote_ip => remote_ip,

            :local_port => new_resource.local_port,
            :remote_port => new_resource.remote_port
        )
        owner "root"
        group "root"
        action :create
    end

    template "/etc/drbd.d/global_common.conf" do
        source "global_common.conf.erb"
        variables(
            :usage_count => new_resource.usage_count,
            :protocol => new_resource.protocol,
            :rate => new_resource.sync_rate
        )
        owner "root"
        group "root"
        action :create
    end
end
