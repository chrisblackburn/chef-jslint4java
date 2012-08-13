#
# Cookbook Name:: jslint4java
# Recipe:: default
#
# Author:: Chris Blackburn (<christopher.blackburn@gmail.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "unzip::default"

src_url = "http://jslint4java.googlecode.com/files/jslint4java-#{node[:jslint4java][:version]}-dist.zip"
jar_file = "jslint4java-#{node[:jslint4java][:version]}.jar"
installed_jar = "#{node[:jslint4java][:destination]}/#{jar_file}"

directory node[:jslint4java][:destination] do
  mode 0755
  owner node[:jslint4java][:user]
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/jslint4java.zip" do
  source src_url
  action :create_if_missing
end

bash "extract_and_move_jslint4java" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    unzip jslint4java
    mv jslint4java-#{node[:jslint4java][:version]}/#{jar_file} #{installed_jar}
    chown #{node[:jslint4java][:user]} #{installed_jar}
  EOH
  not_if "test -f #{installed_jar}"
end
