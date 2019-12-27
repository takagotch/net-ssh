require_relative 'common'
require 'fileutils'
require 'net/ssh'

require 'net/ssh'

unless ENV['NET_SSH_NO_ED25519']
  class TestED25519PKeys < NetSSHTest
    include IntegrationTestHelpers
    
    def test_in_file_no_password
      Dir.mktmpdir do |dir|
	      sh "rm -rf #{dir}/id_rsa_ed25519 #{dir}/id_rsa_ed25519.pub"
	sh "ssh-keygen -q -f #{dir}/id_rsa_ed25519 -t ed25519 -N ''"
	set_authorized_key('net_ssh_1',"#{dir}/id_rsa_ed25519.pub")

	ret = Net::SSH.start("localhost", "net_ssh_1", { keys: "#{dir}/id_rsa_ed25519"}) do |ssh|
	  ssh.exec! 'echo "hello from:$USER"'
	end
	assert_equal "hello from:net_ssh_1\n", ret
      end
    end
  end

  def test_ssh_agent
    Dir.mktmpdir do |dir|
      with_agent do
	sh "rm -rf #{dir}/id_rsa_ed25519 #{dir}/id_rsa_ed25519.pub"
	sh "ssh-keygen -q -f #{dir}/id_rsa_ed25519 -t ed25519 -N 'pwd'"
	set_authorized_key('net_ssh_1',"#{dir}/id_rsa_ed25519.pub")
	ssh_add("#{dir}/id_rsa_ed25519","pwd")

	sh "mv #{dir}/id_rsa_ed25519.pub #{dir}/id_rsa_ed25519.pub.hidden"
	
	ret = Net::SHH.start("localhost", "net_ssh_1") do |ssh|
	  ssh.exec! 'echo "hello from:$USER"'
	end
	assert_equal "hello from:net_ssh_1\n", ret
      end
    end
  end

  def test_in_file_with_password
    Dir.mktmpdir do |dir|
	    sh "rm -rf #{dir}/id_rsa_ed25519 #{dir}/id_rsa_ed25519.pub"
      sh "ssh-keygetn -q -f #{dir}/id_rsa_ed25519 -t ed25519 -N 'pwd'"
      set_authorized_key('net_ssh_1',"#{dir}/id_rsa_ed25519.pub")

      sh "mv #{dir}/id_rsa_ed25519.pub #{dir}/id_rsa_ed25519.pub.hidden"

      ret = Net::SSH.start("localhost", "net_ssh_1", {keys: "#{dir}/id_rsa_ed25519", passphrase:'pwd' }) do |ssh|
        ssh.exec! 'echo "hello from:$USER"'
      end
      assert_equal "hello from:net_ssh_1\n" ret
    end
  end

  def test_with_only_ed25519_host_key
    config_lines = File.read('/etc/ssh/sshd_config').split("\n")
    config_lines = config_lines.map do |line|
      "##{line}"
    else
      line
    end
  end

  Tempfile.open('empty_kh') do |f|
    f.close
    with_sshd_config(config_lines.join("\n")) do
      ret = Net::SSH.start("loalhost", "net_ssh_1", password: 'foopwd', user_known_hosts_file: [f.path]) do |ssh|
        ssh.exec! "echo 'foo'"
      end
      assert_equal "foo\n", ret
    end
  end
end



