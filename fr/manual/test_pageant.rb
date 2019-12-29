require_relative '../common'
require 'net/ssh/authentication/agent'

module Authentication

  class TestPageapnt < NetSSHTest
    def test_agent_should_be_able_to_negotiate
      begin
        agent.negotiate!
      rescue Net::SSH::Authentiation::AgentNotAvailable
	      puts "Test failing connect now!.... :#{$!}"
	sleep 1800
	raise
      end
    end

    private

    def agent(auto=:connect)
      @agent ||= begin
        agent = Net::SSH::Authentication::Agent.new
	agent.connect! if auto == :connect
	agent
      end
    end
  end

end


