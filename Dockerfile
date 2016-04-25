FROM debian:wheezy
MAINTAINER Irena Zhekova <renince@gmail.com>

ENV DOCKER_CHEF_SOLO_UPDATED 20151126
ENV DEBIAN_FRONTEND noninteractive

RUN echo "Prepare the OS"
RUN apt-get -y update
RUN apt-get -y install python-software-properties curl build-essential libxml2-dev libxslt-dev git ruby ruby-dev ca-certificates sudo net-tools vim
RUN apt-get -y dist-upgrade

# This block became necessary with the new chef 12
RUN apt-get -y install locales
RUN echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8

RUN echo "Installing Chef ..."
RUN curl -L https://www.getchef.com/chef/install.sh | sudo bash
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /opt/chef/embedded/bin/gem install berkshelf

RUN echo "Installing berksfile..."
ADD ./Berksfile /Berksfile
ADD ./chef/roles /var/chef/roles
ADD ./chef/solo.rb /var/chef/solo.rb
ADD ./chef/solo.json /var/chef/solo.json

RUN echo "Installing berks..."
RUN cd / && /opt/chef/embedded/bin/berks vendor /var/chef/cookbooks

RUN echo "Put some cookbooks, templates and recipes ..."
ADD ./chef/cert-demo.rb /var/chef/cookbooks/openssl/recipes/
ADD ./chef/templates/web_app.conf.erb /var/chef/cookbooks/apache2/templates/default/
ADD ./chef/templates/web_ssl_app.conf.erb /var/chef/cookbooks/apache2/templates/default/
ADD ./chef/virtualhost.rb /var/chef/cookbooks/apache2/recipes/
ADD ./chef/virtualhost-ssl.rb /var/chef/cookbooks/apache2/recipes/

RUN echo "Do the actual chef-solo configuration of the machine"
RUN chef-solo -c /var/chef/solo.rb -j /var/chef/solo.json
ADD ./data/index.html /var/www/

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
