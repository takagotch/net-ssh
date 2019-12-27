require 'common'
require 'net/ssh/connection/channel'

module Connection

  class TestChannel < NetSSHTest
    include Net::SSH::Connection::Constants

    def teardown
    end

    def test_constructor_should_set_defaults
    end

    def test_channel_properties
    end

    def test_exec_should_be_syntactic_sugar_for_a_channel_request
    end

    def test_subsystem_should_be_syntactic_sugar_for_a_channel_request
    end

    def test_request_pty_with_invalid_option_should_raise_error
    end




  end

end



