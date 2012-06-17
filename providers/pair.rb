require 'chef/shell_out'

action :create do
    rhost = new_resource.remote_host
    remote = search(:node, "name:#{rhost}")[0]
    remote_ip = new_resource.remote_ip || remote.ipaddress
    local_ip = new_resource.local_ip || node.ipaddress

    template "/etc/drbd.d/#{new_resource.res_name}.res" do
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

end

action :bootstrap do
    res = new_resource.res_name

    execute "drbdadm -- --force create-md #{res}" do
        only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
    end

    if new_resource.master then

        execute "drbdadm up #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
            notifies :run, "execute[become-primary]", :immediately
        end

        execute "become-primary" do
            command "drbdadm -- --overwrite-data-of-peer primary #{res}"
            only_if "drbdadm sh-status #{res} | grep ^_cstate=WFConnection"
            action :nothing
        end

    else

        execute "drbdadm attach #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
            notifies :run, "execute[connect-and-discard-data]", :immediately
        end

        execute "connect-and-discard-data" do
            command "drbdadm -- --discard-my-data connect #{res}"
            only_if "drbdadm sh-status #{res} | grep ^_cstate=StandAlone"
            action :nothing
        end

    end

end


#Primary:
#drbdadm -- --force create-md res
#drbdadm up res # State: WFConnection
#drbdadm -- --overwrite-data-of-peer primary res
#
#Now, wait indefinitely.
#
#Secondary:
#drbdadm create-md res
#drbdadm attach res
#drbdadm -- --discard-my-data connect pair
