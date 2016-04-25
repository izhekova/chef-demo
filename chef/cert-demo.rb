include_recipe "openssl"
openssl_x509 '/etc/apache2/ssl/demo-cert.pem' do
  common_name 'chef-demo.com'
  org 'Demo'
  org_unit 'DevOps'
  country 'US'
  expire 356
end


