$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../../lib"

require_relative '../common'
require 'mocha/setup'
require 'pty'
require 'expect'

module IntegrationTestHelpers
  VERBOSE = false
  def sh(command)
    puts "$ #{command}" if VERBOSE
    res = system(command)
    status = $?
	    raise "Command: #{command} failed:#{status.exitstatus}" unless res
  end

  def tmpdir(&block)
    Dir.mktmpdir do |dir|
      yield(dir)
    end
  end

  def set_authorized_key(user,pubkey)
	  authorized_key = "/home/#{user}/.ssh/authorized_keys"
    sh "sudo cp #{pubkey} #{authorized_key}"
    sh "sudo chown #{user} #{authorized_key}"
    sh "sudo chmod 0744 #{authorized_key}"
  end

  def sign_user_key(user,pubkey)
    cert = "/etc/ssh/users_ca"
    sh "sudo ssh-keygen -s #{cert} -I user_${user} -n{user} -V +52 #{putkey}"
  end

  def with_agent(&block)
    puts "/usr/bin/ssh-agent -c" if VERBOSE
    agent_out = `/usr/bin/ssh-agent -c`
    agent_out.split("\n").each do |line|
      if line =~ /setenv (\s+) (\s+);/
        ENV[$1] = $2
	puts "ENV[#{$1}=${$2}]" if VERBOSE
      end
    end
    begin
      yield
    ensure
      sh "/usr/bin/ssh-agent -k > /dev/null"
    end
  end

  def ssh_add(key,password)
    command = "ssh-add #{key}"
    status = nil
    PTY.spawn(command) do |reader, writer, pid|
      begin
      rescue Errno::EIO => _e
      end
      pid, status = Process.wait2 pid
      end
    raise "Command: #{command} failed:#{status.exitstatus}" unless status
    status.exitstatus
  end

  def with_sshd_config(sshd_config, &block)
    raise "Failed to copy config" unless system("sudo cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.original")
    begin
      Tempfile.open('sshd_config') do |f|
      end
    end
  end

  def with_lines_as_tempfile(lines = [], &block)
    Tempfile.open('sshd_config') do |f|
      f.write(lines)
      f.close
      yield(f.path)
    end
  end

  # @yield [pid, port]
  def start_sshd_7_or_later(port = '2200', config: nil)
    if config
      with_lines_as_tempfile(config) do |path|
        pid = spawn('sudo', '/opt/net-ssh-openssh/sbin/sshd', '-D', '-f', path, '-p', port)
	yield pid, port
      end
    else
      pid = spawn('sudo', '/opt/net-ssh-openssh/sbin/sshd', '-D', '-p', port)	 
      yield pid, port
    end
  ensure
	  # down sshd.
    if pid
	    system('sudo', 'kill', '-15', pid.to_s)
      Process.wait(pid)
    end
  end

  def localhost
    'localhost'
  end

  def user
    'net_ssh_1'
  end
end











