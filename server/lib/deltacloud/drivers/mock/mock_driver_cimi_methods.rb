#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.
#
#Definition of CIMI methods for the mock driver - seperation from deltacloud
#API mock driver methods

module Deltacloud::Drivers::Mock

  class MockDriver < Deltacloud::BaseDriver

    def systems(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        systems = @client.load_all_cimi(:system).map{|sys| CIMI::Model::System.from_json(sys)}
      else
        begin
          systems = [CIMI::Model::System.from_json(@client.load_cimi(:system, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      systems.map{|sys|convert_cimi_mock_urls(:system, sys ,opts[:env])}.flatten
    end

    def create_system(credentials, opts={})
      check_credentials(credentials)
      id = "#{opts[:env].send("systems_url")}/#{opts[:name]}"
      sys_hsh = { "id"=> id,
                  "name" => opts[:name],
                  "description" => opts[:description],
                  "created" => Time.now,
                  "state" => "STOPPED",
                  "systemTemplate"=> { "href" => opts[:system_template].id },
                  "operations" => [{"rel"=>"edit", "href"=> id},
                                   {"rel"=>"delete", "href"=> id}]    }
      system = CIMI::Model::System.from_json(JSON.generate(sys_hsh))

      @client.store_cimi(:system, system)
      system
    end

    def destroy_system(credentials, id)
      check_credentials(credentials)
      @client.destroy_cimi(:system, id)
    end

    def start_system(credentials, id)
      check_credentials(credentials)
      update_object_state(id, "System", "STARTED")
    end

    def stop_system(credentials, id)
      check_credentials(credentials)
      update_object_state(id, "System", "STOPPED")
    end

    def system_machines(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        machines = @client.load_all_cimi(:system_machine).map{|mach| CIMI::Model::SystemMachine.from_json(mach)}
      else
        begin
          machines = [CIMI::Model::SystemMachine.from_json(@client.load_cimi(:system_machine, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      #FIXME: with ":machines", delete url becomes 'http://localhost:3001/cimi/machines?id=sysmach1'
      #with ":system_machine"/":system_machines", undefined method `system_machine_url' for #<CIMI::Collections::Systems:0x44fe338> in mock_driver_cimi_methods.rb:261
      machines.map{|mach|convert_cimi_mock_urls(:machines, mach, opts[:env])}.flatten
    end

    def system_volumes(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        volumes = @client.load_all_cimi(:system_volume).map{|vol| CIMI::Model::SystemVolume.from_json(vol)}
      else
        begin
          volumes = [CIMI::Model::SystemVolume.from_json(@client.load_cimi(:system_volume, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      #FIXME: with ":volumes", delete url becomes 'http://localhost:3001/cimi/volumes?id=sysvol1'
      #with ":system_volume"/":system_volumes", undefined method `system_volume_url' for #<CIMI::Collections::Systems:0x44fe338> in mock_driver_cimi_methods.rb:261
      volumes.map{|vol|convert_cimi_mock_urls(:volumes, vol, opts[:env])}.flatten
    end

    def system_networks(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        networks = @client.load_all_cimi(:system_network).map{|net| CIMI::Model::SystemNetwork.from_json(net)}
      else
        begin
          networks = [CIMI::Model::SystemNetwork.from_json(@client.load_cimi(:system_network, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      #FIXME
      networks.map{|vol|convert_cimi_mock_urls(:networks, vol, opts[:env])}.flatten
    end

    def system_addresses(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        addresses = @client.load_all_cimi(:system_address).map{|a| CIMI::Model::SystemAddress.from_json(a)}
      else
        begin
          addresses = [CIMI::Model::SystemVolume.from_json(@client.load_cimi(:system_address, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      #FIXME
      addresses.map{|a|convert_cimi_mock_urls(:addresses, a, opts[:env])}.flatten
    end

    def system_forwarding_groups(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        groups = @client.load_all_cimi(:system_forwarding_group).map{|group| CIMI::Model::SystemForwardingGroup.from_json(group)}
      else
        begin
          groups = [CIMI::Model::SystemForwardingGroup.from_json(@client.load_cimi(:system_forwarding_group, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      #FIXME
      groups.map{|group|convert_cimi_mock_urls(:forwarding_groups, group, opts[:env])}.flatten
    end

    def system_templates(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        system_templates = @client.load_all_cimi(:system_template).map{|sys_templ| CIMI::Model::SystemTemplate.from_json(sys_templ)}
      else
        begin
          system_templates = [CIMI::Model::SystemTemplate.from_json(@client.load_cimi(:system_template, opts[:id]))]
        rescue Errno::ENOENT
          return []
        end
      end
      system_templates.map{|sys_templ|convert_cimi_mock_urls(:system_template, sys_templ, opts[:env])}.flatten
    end

    def networks(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        networks = @client.load_all_cimi(:network).map{|net| CIMI::Model::Network.from_json(net)}
        networks.map{|net|convert_cimi_mock_urls(:network, net ,opts[:env])}.flatten
      else
        network = CIMI::Model::Network.from_json(@client.load_cimi(:network, opts[:id]))
        convert_cimi_mock_urls(:network, network, opts[:env])
      end
    end

    def create_network(credentials, opts={})
      check_credentials(credentials)
      id = "#{opts[:env].send("networks_url")}/#{opts[:name]}"
      net_hsh = { "id"=> id,
                  "name" => opts[:name],
                  "description" => opts[:description],
                  "created" => Time.now,
                  "state" => "STARTED",
                  "networkType" => opts[:network_config].network_type,
                  "mtu" =>  opts[:network_config].mtu,
                  "classOfService" => opts[:network_config].class_of_service,


                  "forwardingGroup"=> { "href" => opts[:forwarding_group].id },
                  "operations" => [{"rel"=>"edit", "href"=> id},
                                   {"rel"=>"delete", "href"=> id}]    }
      network = CIMI::Model::Network.from_json(JSON.generate(net_hsh))

      @client.store_cimi(:network, network)
      network
    end

    def delete_network(credentials, id)
      check_credentials(credentials)
      @client.destroy_cimi(:network, id)
    end

    def start_network(credentials, id)
      check_credentials(credentials)
      update_object_state(id, "Network", "STARTED")
    end

    def stop_network(credentials, id)
      check_credentials(credentials)
      update_object_state(id, "Network", "STOPPED")
    end

    def suspend_network(credentials, id)
      check_credentials(credentials)
      update_object_state(id, "Network", "SUSPENDED")
    end

    def network_configurations(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        network_configs = @client.load_all_cimi(:network_configuration).map{|net_config| CIMI::Model::NetworkConfiguration.from_json(net_config)}
        network_configs.map{|net_config|convert_cimi_mock_urls(:network_configuration, net_config, opts[:env])}.flatten
      else
        network_config = CIMI::Model::NetworkConfiguration.from_json(@client.load_cimi(:network_configuration, opts[:id]))
        convert_cimi_mock_urls(:network_configuration, network_config, opts[:env])
      end
    end

    def network_templates(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        network_templates = @client.load_all_cimi(:network_template).map{|net_templ| CIMI::Model::NetworkTemplate.from_json(net_templ)}
        network_templates.map{|net_templ|convert_cimi_mock_urls(:network_template, net_templ, opts[:env])}.flatten
      else
        network_template = CIMI::Model::NetworkTemplate.from_json(@client.load_cimi(:network_template, opts[:id]))
        convert_cimi_mock_urls(:network_template, network_template, opts[:env])
      end
    end

    def forwarding_groups(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        forwarding_groups = @client.load_all_cimi(:forwarding_group).map{|fg| CIMI::Model::ForwardingGroup.from_json(fg)}
        forwarding_groups.map{|fg|convert_cimi_mock_urls(:forwarding_group, fg, opts[:env])}.flatten
      else
        forwarding_group = CIMI::Model::ForwardingGroup.from_json(@client.load_cimi(:forwarding_group, opts[:id]))
        convert_cimi_mock_urls(:forwarding_group, forwarding_group, opts[:env])
      end
    end

    def forwarding_group_templates(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        forwarding_group_templates = @client.load_all_cimi(:forwarding_group_template).map{|fg_templ| CIMI::Model::ForwardingGroupTemplate.from_json(fg_templ)}
        forwarding_group_templates.map{|fg_templ|convert_cimi_mock_urls(:forwarding_group_template, fg_templ, opts[:env])}.flatten
      else
        forwarding_group_template = CIMI::Model::ForwardingGroupTemplate.from_json(@client.load_cimi(:forwarding_group_template, opts[:id]))
        convert_cimi_mock_urls(:forwarding_group_template, forwarding_group_template, opts[:env])
      end
    end

    def network_ports(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        ports = @client.load_all_cimi(:network_port).map{|net_port| CIMI::Model::NetworkPort.from_json(net_port)}
        ports.map{|net_port|convert_cimi_mock_urls(:network_port, net_port, opts[:env])}.flatten
      else
        port = CIMI::Model::NetworkPort.from_json(@client.load_cimi(:network_port, opts[:id]))
        convert_cimi_mock_urls(:network_port, port, opts[:env])
      end
    end

    def network_port_configurations(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        network_port_configurations = @client.load_all_cimi(:network_port_configuration).map{|network_port_config| CIMI::Model::NetworkPortConfiguration.from_json(network_port_config)}
        network_port_configurations.map{|network_port_config|convert_cimi_mock_urls(:network_port_configuration, network_port_config, opts[:env])}.flatten
      else
        network_port_configuration = CIMI::Model::NetworkPortConfiguration.from_json(@client.load_cimi(:network_port_configuration, opts[:id]))
        convert_cimi_mock_urls(:network_port_configuration, network_port_configuration, opts[:env])
      end
    end

    def network_port_templates(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        network_port_templates = @client.load_all_cimi(:network_port_template).map{|net_port_templ| CIMI::Model::NetworkPortTemplate.from_json(net_port_templ)}
        network_port_templates.map{|net_port_templ|convert_cimi_mock_urls(:network_port_template, net_port_templ, opts[:env])}.flatten
      else
        network_port_template = CIMI::Model::NetworkPortTemplate.from_json(@client.load_cimi(:network_port_template, opts[:id]))
        convert_cimi_mock_urls(:network_port_template, network_port_template, opts[:env])
      end
    end

    def address_templates(credentials, opts={})
      check_credentials(credentials)
      if opts[:id].nil?
        address_templates = @client.load_all_cimi(:address_template).map{|addr_templ| CIMI::Model::AddressTemplate.from_json(addr_templ)}
        address_templates.map{|addr_templ|convert_cimi_mock_urls(:address_template, addr_templ, opts[:env])}.flatten
      else
        address_template = CIMI::Model::AddressTemplate.from_json(@client.load_cimi(:address_template, opts[:id]))
        convert_cimi_mock_urls(:address_template, address_template, opts[:env])
      end
    end

    private

    def convert_cimi_mock_urls(model_name, cimi_object, context)
      cimi_object.attribute_values.each do |k,v|
        if ( v.is_a?(Struct) || ( v.is_a?(Array) && v.first.is_a?(Struct)))
          case v
            when Array
              v.each do |item|
                convert_struct_urls(item, k.to_s.singularize.to_sym, context)
              end
            else
              opts = nil
              if is_subcollection?(v, cimi_object.id)
                opts = {:parent_model_name => model_name, :parent_item_name => cimi_object.name}
              end
              convert_struct_urls(v, k, context, opts)
            end
        end
      end
      object_url = context.send(:"#{model_name}_url", cimi_object.name)
      cimi_object.id=object_url
      cimi_object.operations.each{|op| op.href=object_url  }
      cimi_object
    end

    def is_subcollection?(struct, cimi_object_id)
      return false if struct.href.nil?
      struct.href.include?(cimi_object_id)
    end

    def convert_struct_urls(struct, cimi_name, context, opts = nil)
      return unless (struct.respond_to?(:href) && (not struct.href.nil?) && (not cimi_name == :operation ))
      if opts
        struct.href = context.send(:"#{opts[:parent_model_name]}_url", opts[:parent_item_name]) + "/#{cimi_name}"
      else
        obj_name = struct.href.split("/").last
        if cimi_name.to_s.end_with?("config")
          struct.href = context.send(:"#{cimi_name}uration_url", obj_name)
        else
          struct.href = context.send(:"#{cimi_name}_url", obj_name)
        end
      end
    end

    def update_object_state(id, object, new_state)
      klass = CIMI::Model.const_get("#{object}")
      symbol = object.to_s.downcase.singularize.intern
      obj = klass.from_json(@client.load_cimi(symbol, id))
      obj.state = new_state
      @client.store_cimi(symbol, obj)
      obj
    end

  end

end
