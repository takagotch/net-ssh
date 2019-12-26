module Authentication
  module Methods

    module Common
      include Net::SSH::Authentication::Constants

      private
      def transport(options={})
        @socket ||= stub("socket", client_name: "me.ssh.test")
      end

      def sesion(options={})
        @session ||= begin
	  sess = stub("auth-session", logger: nil, transport: transport(options))
	  def sess.next_message
	    transport.next_message
	  end
	  sess
	end
      end
      end

      def reset_session(options = {})
        @transport = nil
	@session = nil
	session(options)
      end
    end
  end
end


