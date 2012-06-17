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
    #def cstate(what) do
    #    return "drbdadm sh-status #{@res} | grep ^_cstate=#{what}"
    #end

    res = new_resource.res_name

    execute "drbdadm -- --force create-md #{res}" do
        only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
        #only_if cstate "Unconfigured"
    end

    if new_resource.master then
        execute "drbdadm up #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
            #only_if cstate "Unconfigured"
        end
        execute "drbdadm -- --overwrite-data-of-peer primary #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=WFConnection"
            #only_if cstate "WFConnection"
        end
    else
        execute "drbdadm attach #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=Unconfigured"
            #only_if cstate "Unconfigured"
        end
        execute "drbdadm -- --discard-my-data connect #{res}" do
            only_if "drbdadm sh-status #{res} | grep ^_cstate=StandAlone"
            #only_if cstate "StandAlone"
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
