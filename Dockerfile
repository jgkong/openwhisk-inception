FROM jgkong/ubuntu-docker
MAINTAINER jgkong@kr.ibm.com

# Set environment variables.
#ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -qq libyaml-dev && \
  # misc.sh
  echo "Etc/UTC" | sudo tee /etc/timezone && \
  dpkg-reconfigure --frontend noninteractive tzdata && \
  apt-get install -qq ntp git zip && \
  service ntp restart && \
  ntpq -c lpeer && \
  # pip.sh
  apt-get install -qq python-pip && \
  pip install jsonschema argcomplete couchdb && \
  # java8.sh
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -qq && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
  apt-get install -qq oracle-java8-installer && \
  # scala.sh
  curl -fsSLo /tmp/scala-2.11.6.deb https://www.scala-lang.org/files/archive/scala-2.11.6.deb && \
  dpkg -i /tmp/scala-2.11.6.deb && \
  apt-get update -qq && \
  apt-get install -qq scala && \
  rm -f /tmp/scala-2.11.6.deb && \
  # ansible.sh
  apt-add-repository -y ppa:ansible/ansible && \
  apt-get update -qq && \
  apt-get install -qq python-dev libffi-dev libssl-dev && \
  pip install markupsafe ansible==2.3.0.0 docker==2.2.1 && \
  # cleanup
  apt-get autoremove -qq && \
  apt-get clean autoclean && \
  rm -rf /tmp/* /var/tmp/* /var/log/*.log /var/log/apt/*.log && \
  # delete all the apt list files since they're big and get stale quickly
  rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

