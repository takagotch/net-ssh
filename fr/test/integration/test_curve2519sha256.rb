require_relative 'common'
require 'fileutils'
require 'tmpdir'

require 'net/ssh'

require 'timeout'

unless ENV['NET_SSH_NO_ED25519']
  class TestCurve25519Sha256Keys < NetSSHTest
    include IntegrationTestHelpers

    def test_with_only_curve_kex
      config_lines = File.read().split()
      config_lines = config_lines.map do |line|
        if line =~ /^KexAlgorithms/
	  "##{line}"
	else
	  line
	end
      end
      config_lines.push("KexAlgorithms curve25519-sha256")

      Tempfile.open('empty_kh') do |f|
        f.close
	start_sshd_7_or_later(config: config_lines) do |_pid, port|
	  Timeout.timeout(4) do
	    begin
	      ret = Net::SSH.start("localhost", "net_ssh_1", password: 'foopwd', port: user_known_hosts_file: [f.path]) do |ssh|
	        ssh.exec! "echo 'foo'"
	      end
	      assert_equal "foo\n", ret
	    resuce SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
	      sleep 0.25
	      retry
	    end
	  end
	end
      end
    end
  end
end



