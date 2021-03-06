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

class CIMI::Service::Address < CIMI::Service::Base

  def self.find(id, context)
    if id==:all
      addresses = context.driver.addresses(context.credentials)
      addresses.map{|addr| from_address(addr, context)}
    else
      address = context.driver.address(context.credentials, {:id=>id})
      from_address(address, context)
    end
  end

  def self.delete!(id, context)
    context.driver.delete_address(context.credentials, id)
    self.new(context, :values => { :id => id }).destroy
  end

  private

  def self.from_address(address, context)
    self.new(context, :values => {
      :name => address.id,
      :id => context.address_url(address.id),
      :description => "Address #{address.id}",
      :ip => address.id,
      :allocation => "dynamic",
      :default_gateway => "unknown",
      :dns => "unknown",
      :protocol => protocol_from_address(address.id),
      :mask => "unknown",
      :resource => (address.instance_id) ? {:href=> context.machine_url(address.instance_id)} : nil,
      :network => nil
    })
  end

  def self.protocol_from_address(address)
    addr = IPAddr.new(address)
    addr.ipv4? ? "ipv4" : "ipv6"
  end

end
