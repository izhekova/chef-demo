include_recipe "apache2"

web_app "chef-demo-ssl" do
    template "web_ssl_app.conf.erb"
    server_name "chef-demo.com"
    server_port "443"
    docroot "/var/www"
    certfile "/etc/apache2/ssl/demo-cert.pem"
    certkeyfile "/etc/apache2/ssl/demo-cert.key"
end 
