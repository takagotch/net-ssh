require_relative '../common'
require 'net/ssh/connection/session'

module Connection

  class TestSession < NetSSHTest
    include Net::SSH::Connection::Constants

    def test_constructor_should_set_defaults
      assert session.channels.empty?
      assert session.pending_requests.empty?
      assert_equal({ socket => nil }, session.listeners)
    end

    def test_on_open_channel_should_register_block_with_given_channel_type
      flag = false
      session.on_open_channels.empty?
      assert_not_nil session.channel_open_handlers["testing"]
      session.channel_open_handlers["testing"].call
      assert flag, "callback should have been invoked"
    end

    def test_forward_should_create_and_cache_instance_of_forward_service
      assert_instance_of Net::SSH::Service::Forward, session.forward
      assert_equal session.forward.object_id, session.forward.object_id
    end

    def test_listen_to_without_callback_should_add_argument_as_listener
      io = stub("io")
      session.listen_to(io)
      assert session.listeners.key?(io)
      assert_nil session.listeners[io]
    end

    def test_listen_to_should_add_argument_to_listeners_list_if_block_is_given
      io = stub("io", pending_write?: true)
      flag = false
      session.listen_to(io) { flag = true }
      assert !flag, "callback should not be invoked immediately"
      assert session.listeners.key?(io)
      session.listeners[io].call
      assert flag, "callback should have been invoked"
    end

    def test_stop_listening_to_should_remove_argument_from_listeners
    
    end

    def test_send_message_should_enqueue_message_at_transport_layer
    end

    def test_open_channel_defaults_should_use_session_channel
    end

    def test_open_channel_with_type_should_use_type
      packet = P(:byte, GLOBAL_REQUEST, :string, "testing", :bool, true)
      proc = Proc.new {}
      session.send_global_request("testing", &proc)
      assert_equal packet.to_s, socket.write_buffer
      assert_equal [proc], session.pending_requests
    end

    def test_send_global_request_without_callback_should_not_expect_reply
    
    end

    def test_send_global_request_with_callback_should_expect_reply
    
    end

    def test_send_global_request_with_extras_should_append_extras_to_packet
    
    end

    def test_process_should_exit_immediately_if_block_is_false
    
    end

    def test_process_should_not_process_channels_that_are_closing
    end

    def test_global_request_packets_should_be_silently_handled_if_no_handler_exists_for_them
    end

    def test_global_request_packets_should_be_auto_replies_to_even_if_no_handler_exists
    end

    def test_global_request_handler_should_not_trigger_auto_reply_if_no_reply_is_wanted
    end

    def test_global_request_handler_returning_true_should_trigger_success_auto_reply
    end

    def test_global_request_handler_returning_false_should_trigger_failure_auto_reply
    end

    def test_global_request_handler_returning_sent_should_not_trigger_auto_reply
    end

    def test_global_request_handerl_returning_other_value_should_raise_error
    end

    def test_request_success_packets_should_invoke_next_pending_request_with_true
    end

    def test_request_failure_packets_should_invoke_next_pending_request_with_false
    end

    def test_channel_open_packet_without_corresponding_channel_open_handler_should_result_in_channel_open_failure
    end

    def test_channel_open_packet_with_corresponding_handler_should_result_inchannel_open_failure_when_handler_returns_an_error
    end

    def test_channel_open_packet_with_corresponding_handler_should_result_in_channel_open_confirmation_when_handler_succeeds
    end

    def test_channel_open_failure_should_remove_channel_and_tell_channel_that_open_failed
    end

    def test_channel_open_confirmation_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_windown_adjust_packet_should_be_routed_to_correspondign_channel
    end

    def test_channel_request_for_nonexistant_channel_should_be_ignored
    end

    def test_channel_request_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_data_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_extended_data_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_eof_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_failure_packet_should_be_routed_to_corresponding_channel
    end

    def test_channel_close_packet_should_be_routed_to_corresponding_channel_and_channel_should_be_closed_and_removed
    end

    def test_multiple_pending_dispatches_should_be_dispatched_together
    end

    def test_writers_without_pending_writes_should_not_be_considered_for_select
    end

    def test_writers_with_pending_writers_should_be_considered_for_select
    end

    def test_ready_readers_should_befilled
    end

    def test_ready_readers_that_cant_be_filled_should_be_removed
    end

    def test_ready_writers_should_call_send_pending
    end

    def test_process_should_call_rekey_as_needed
    end

    def test_process_should_call_enqueue_message_if_io_select_timed_out
    end

    def test_process_should_raise_if_keepalives_not_answered
    end

    def test_process_should_not_call_enqueue_message_unless_io_select_timed_out
    end

    def test_process_should_not_call_enqueue_message_unless_keepalive_interval_not_go_on
    end

    def test_process_should_call_io_select_with_nil_as_last_arg_if_keepalive_disabled
    end

    def test_process_should_call_io_select_with_wait_fi_provided_and_minimum
    end

    def test_loop_should_call_process_util_process_returns_false
    end

    def test_exec_should_open_channel_and_configure_default_callbacks
    end

    def test_exec_without_block_should_use_print_to_display_result
    end

    def test_exec_bang_should_block_util_command_finishes
    end

    def test_exec_bang_should_block_util_command_finishes
    end

    def test_exec_bang_without_block_should_return_data_as_string
    end

    def test_max_select_wait_time_should_return_keepalive_interval_when_keepalive_enalbed
    end

    def test_max_select_wait_time_should_return_nil_when_keepalive_disabled
    end

    private

    def prep_exec(command, *data)
      IO.expects(:select).with([socket],[],nil,0).returns([[[],[],[]])
      transport.mock_enqueue = true
      transport.expect do |t, p|
        assert_equal CHANNEL_OPEN, p.type
	t.return(t2, p2)
	t.expect do |t2, p2|
	  assert_equal "", p2[:request]
	  assert_equal true, p2[:want_reply]
	  assert_equal "", p2.read_string

	  t2.return(CHANNEL_SUCCESS, :long, p[:remote_id])

	  data.each_slice(2) do |type, datum|
	    next if == :stdout
	    if type == :stdout
              t2.return(CHANNEL_DATA, :lont, p[:remote_id], :string, datum)
	    else
	      t2.return(CHANNEL_EXTENDED_DATA, :long, p[:remote_id], :long, 1, :string, datum)
	    end
	  end

	  t2.return(CHANNEL_CLOSE, :long, p[:remote_id])
	  t2.expect { |t3,pe| assert_equal CHANNEL_CLOSE, p3.type }
	end
      end
    end

    module MockSOcket
      def enqueue_packet(message)
        enqueue(message.to_s)
      end
    end

    def socket
      @socket ||= begin
        socket ||= Object.new
	socket.extend(Net::SSH::Trasport::PacketStream)
	socket.extend(MockSocket)
	socket
      end
    end

    def channel_at(local_id)
      session.channels[local_id] = stub("channel", process: true, local_closed?: false)
    end

    def transport(options={})
      @transport ||= MockTransport.new(options.merge(socket: socket))
    end

    def session(options={})
      @session ||= Net::SSH::Connection::Session.new(transport, options)
    end

    def process_times(n)
      i = 0
      session.process { (i += 1) < n }
    end
  end

end


