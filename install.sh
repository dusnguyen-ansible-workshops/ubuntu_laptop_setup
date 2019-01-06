#!/usr/bin/env bash

unamestr=$(uname)

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Boostrapping ..."

# Ensure the system is debian based
if [[ $unamestr == "Linux"  && -f $(which apt-get) ]]; then
    sudo apt-get update
    pip || sudo apt-get install --yes python-pip python-dev git
fi

ansible -h || sudo pip install ansible

# Clone the repository to your local drive.
if [ -d "~/ubuntu_laptop_setup" ]; then
  fancy_echo "Developers Laptop repo dir exists. Removing ..."
  rm -rf ~/ubuntu_laptop_setup/
fi

fancy_echo "Cloning developers laptop repo ..."
git clone https://github.com/dusnguyen-ansible-workshops/ubuntu_laptop_setup.git ~/ubuntu_laptop_setup

fancy_echo "Changing to developers laptop repo dir ..."
cd ~/ubuntu_laptop_setup

# Run this from the same directory as this README file.
fancy_echo "Running ansible playbook ..."
ansible-playbook main.yml -i hosts --ask-become-pass -vvvv

fancy_echo "Cleaning up developers laptop repo dir ..."
rm -rf ~/ubuntu_laptop_setup
