# import JSON custom config into .env to emulate ENV
# example:
# {
#   "deploy": {
#     "app_name" {
#       "app_env": {
#         "DATABASE_URL": "",
#         "bar": "foo"
#       }
#     }
#   }
# }

require 'shellwords'
node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]

  Chef::Log.info("Generating dotenv for app: #{application} with env: #{rails_env}... in #{deploy[:deploy_to]}")

  require 'yaml'

  environment_variables = deploy[:app_env].to_h.merge(deploy[:environment_variables].to_h)

  env_file_content = environment_variables.map{|name,value| "#{name}=#{value.to_s.shellescape}"}.join("\n")

  file "#{deploy[:deploy_to]}/shared/.env" do
    content env_file_content
    owner "deploy"
    group  "www-data"
    mode 00774
  end
end
