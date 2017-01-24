# -*- mode: ruby -*-
# vi: set ft=ruby :

require "json"

projects_dir = "~/projects/ansible"

def host_info_from_ansible(host)
  command = "ansible all -i hosts/#{host}/dev -m debug -a \"var=hostvars\""
  output = `#{command}`
  lines = output.lines
  if lines.empty?
    return false
  end
  if lines.first.count('SUCCESS') != 7
    return false
  end
  results = {}
  lines[0] = "{\n";
  data = JSON.parse(lines.join())
  data["hostvars"].each do |h, info|
    ip = info["app_ip"] || h
    if info["app_env"] == "dev"
      results[ip] = info
    end
  end
  results
end

def dev_hosts(projects)
  hosts = {}
  projects.each do |host|
    result = host_info_from_ansible(host)
    if result
      hosts.merge!(result)
    else
      puts "no dev info for host #{host}"
    end
  end
  hosts
end

def print_projects(projects)
  puts "Please specify a project:"
  projects.each do |p|
    puts "- #{p}"
  end
  exit 1
end

projects = Dir.entries('./hosts').reject {|x| x == '.' or x == '..'}

if ['up', 'halt', 'ssh', 'reload'].include? ARGV[0]
  host = ARGV[1]
  unless ARGV[1]
    if projects.size > 1
      print_projects projects
    else
      host = projects.first
    end
  end

  unless projects.include? host
    puts "Unrecognized project '#{host}'."
    print_projects projects
  end

  hosts = host_info_from_ansible(host)
else
  hosts = dev_hosts(projects)
end


if hosts.empty?
  puts "No dev hosts configured"
  exit 1
end


Vagrant.configure("2") do |vagrant|

  hosts.each do |ip, info|

    name = info["app_name"]
    domain = info["app_domain"]

    vagrant.vm.define name do |config|
      # config.vm.box = "packer/builds/#{name}.box"

      # this is preferred (if not using packer), but there is a bug
      # https://bugs.launchpad.net/cloud-images/+bug/1569237
      # config.vm.box = "ubuntu/xenial64"

      config.vm.box = "bento/ubuntu-16.04"

      config.vm.hostname = domain
      config.vm.network :private_network, ip: ip
      config.ssh.forward_agent = true

      site_dir = File.expand_path "#{projects_dir}/#{name}"

      if File.exist?(site_dir)
        opts = {
          owner: "vagrant",
          group: "www-data",
          mount_options: %w"dmode=775 fmode=775"
        }
        config.vm.synced_folder site_dir, "/var/www/#{name}/dev/current", opts
      end
    end
  end
end
