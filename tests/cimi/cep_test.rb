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

$:.unshift File.join(File.dirname(__FILE__))

require "test_helper.rb"

class CloundEntryPointBehavior < CIMI::Test::Spec

  ROOTS = [ "resourceMetadata", "systems", "systemTemplates",
            "machines" , "machineTemplates", "machineConfigs",
            "machineImages", "credentials", "credentialTemplates",
            "volumes", "volumeTemplates", "volumeConfigs", "volumeImages",
            "networks", "networkTemplates", "networkConfigs", "networkPorts",
            "networkPortTemplates", "networkPortConfigs",
# FIXME: addresses exposes a Rabbit bug
#            "addresses",
            "addressTemplates", "forwardingGroups",
            "forwardingGroupTemplates",
            "jobs", "meters", "meterTemplates", "meterConfigs",
            "eventLogs", "eventLogTemplates" ]

  RESOURCE_URI = "http://schemas.dmtf.org/cimi/1/CloudEntryPoint"

  #  Ensure test executes in test plan order
  i_suck_and_my_tests_are_order_dependent!

  # We'd like to call this :cep, but there's already a method by that name
  model :subject, :cache => true do |fmt|
    cep(:accept => fmt)
  end

  it "should have a valid baseURI" do
    subject.base_uri.must_be_uri
    subject.base_uri.must_match %r{/$}
  end

  it "should have a name" do
    subject.name.wont_be_empty
  end

  it "should have a response code equal to 200" do
    subject
    last_response.code.must_equal 200
  end

  it "should have the correct resourceURI", :only => :json do
    subject.wont_be_nil     # Make sure we talk to the server
    last_response.json["resourceURI"].must_equal RESOURCE_URI
  end

  query_the_cep(ROOTS)

  it "should handle Accept of */*", :only => :json do
    response = RestClient.get(api.cep_url, "Accept" => "*/*")
    response.content_type.must_be_one_of CONTENT_TYPES.values
  end
end
