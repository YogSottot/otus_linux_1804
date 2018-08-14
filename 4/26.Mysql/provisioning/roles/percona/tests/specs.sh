#!/bin/bash
#
# CI provisionning script
#
# This script will prepare CI run environments for Ansible roles
# It can be used in Travis or Vagrant
#
# It will also install itslef in /usr/local/bin/spec for subsequent runs in
# Vagrant
#
# # Vagrant
#
# Usage for provisionning VM & running (in Vagrant file):
# 
# script.sh --install <role>
#
# e.g. : 
# script.sh --install ansible-nginx
# 
# Usage for running after provisionning (from host):
#
# vagrant ssh -c specs
#
# # Travis
#
# In the .travis.yml file, add :
#
# script: ./specs.sh --install <role>
#

# At provisionning time, vagrant runs the provisionning script as "root"
# However we need to act sometimes as vagrant
# On the other hand, when using travis, we always run as travis...
# su_wrap takes care of this whatever environment we're using
function su_wrap() {
  echo "Wrapping ${1}"
  if [ -z "${TRAVIS}" ]; then
    # Running on Vagrant
    su ubuntu -c "${1}"
  else
    eval "$1"
  fi
}

function install() {
  # Check if we're running on Vagrant or Travis
  if [ -z "${TRAVIS}" ]; then
    # Running on vagrant
    eval CI_HOME="$(printf "~%q" "ubuntu")"
    SOURCE="/vagrant"
  else
    # Running on travis
    CI_HOME="${HOME}"
    SOURCE="${TRAVIS_BUILD_DIR}"
  fi

  echo "CI_HOME=${CI_HOME}"
  echo "SOURCE=${SOURCE}"
  echo "TRAVIS=${TRAVIS}"

  # Copy self to /usr/local/bin/specs, replacing ROLENAME with actually tested
  # role
  sed -e "s/_ROLENAME_/$2/" < $(readlink -f $0) | sudo tee /usr/local/bin/specs > /dev/null
  sudo chmod 755 /usr/local/bin/specs

  # Install Git
  if [[ -r "/etc/redhat-release" ]]; then
    sudo yum install -y git
  else
    sudo apt-get update
    sudo apt-get install -y git make python-minimal
  fi

  # Fetch and install rolespec
  su_wrap 'git clone https://github.com/nickjj/rolespec.git'
  cd rolespec && sudo make install
  
  # Create empty test directory
  su_wrap 'ROLESPEC_LIB="/usr/local/lib/rolespec" /usr/local/bin/rolespec -i ~/testdir'

  # Symlinking source in rolespec's role dir
  su_wrap "ln -sf ${SOURCE}/ ~/testdir/roles/$2"

  # Symlinking tests in rolespec's test dir
  su_wrap "ln -sf ${SOURCE}/tests/$2/ ~/testdir/tests/"

  # Symlinks requirements.yml if any
  [ -e ${SOURCE}/requirements.yml ] && su_wrap "ln -sf ${SOURCE}/requirements.yml ~/testdir/"
  
  # Running tests if on travis
  # Running on Vagrant is manual (more practical)
  # On travis, the test has to run straight away !
  if [ -n "${TRAVIS}" ]; then 
    exec /usr/local/bin/specs
  else
    # Execute environment specific stuff on non travis CI
    [ -e ${SOURCE}/tests/prepare_environment.sh ] && ${SOURCE}/tests/prepare_environment.sh
  fi
  exit 0
}

if [ "x$1" == "x--install" ]; then
  # Install mode
  install "$@"
else
  # Run mode
  cd ~/testdir && TRAVIS_REPO_SLUG= ROLESPEC_LIB="/usr/local/lib/rolespec" /usr/local/bin/rolespec -r _ROLENAME_ "$@"
fi
