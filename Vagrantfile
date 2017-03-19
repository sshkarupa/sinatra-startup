# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  # Dependencies / Utiles
  echo "Updating package definitions"
  sudo apt-get update

  echo "Installing git and build tools"
  sudo apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev \
  libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
  libcurl4-openssl-dev python-software-properties libffi-dev > /dev/null 2>&1

  # Rbenv
  if [ ! -d ~/.rbenv ]; then
    echo "Installing rbenv and ruby-build"

    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  else
    echo "Updating rbenv and ruby-build"

    cd ~/.rbenv && git pull
    cd ~/.rbenv/plugins/ruby-build && git pull
  fi

  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"

  # Ruby
  if [ ! -d "$HOME/.rbenv/versions/$(cat /vagrant/.ruby-version)" ]; then
    echo "Installing ruby"

    rbenv install $(cat /vagrant/.ruby-version)
    rbenv global $(cat /vagrant/.ruby-version)

    gem update --system
    gem update
    gem install bundler --no-rdoc --no-ri
    rbenv rehash
  fi

  # Gems
  cd /vagrant
  bundle install

  # Postgres
  echo "Installing postgresql"
  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y postgresql-common > /dev/null 2>&1
  sudo apt-get install -y postgresql-9.5 libpq-dev > /dev/null 2>&1

  if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='vagrant'" | grep -q 0; then
    sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
    sudo -u postgres psql -c "ALTER USER vagrant CREATEDB;"
  fi
  echo "DONE"
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.network 'private_network', ip: '172.168.35.10'

  config.vm.provider :virtualbox do |vb|
    vb.memory = '2048'
  end

  config.vm.provision :shell, privileged: false, inline: $script
end
