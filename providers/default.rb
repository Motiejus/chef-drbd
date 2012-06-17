action :setup do
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
