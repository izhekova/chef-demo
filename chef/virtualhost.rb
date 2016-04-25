include_recipe "apache2"

web_app "chef-demo" do
  server_name "chef-demo.com"
  server_aliases ["www.chef-demo.com.localhost"]
  docroot "/var/www"
end
