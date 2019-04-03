require 'request_store'

module MnMiddleware
  class RemoteIpLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["HTTP_X_FORWARDED_FOR"]
        remote_ip = env["HTTP_X_FORWARDED_FOR"].split(",")[0]
        env['REMOTE_ADDR'] = env["action_dispatch.remote_ip"] = env["HTTP_X_FORWARDED_FOR"] = remote_ip
        RequestStore.store[:remote_ip] = remote_ip
        @app.call(env)
      else
        @app.call(env)
      end
    end
  end
end