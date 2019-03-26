require 'securerandom'
require 'net/http'

class MnMiddleware::CorrelationId
  def initialize app
    @app = app
  end

  def call(env)
    request_id = nil

    # see if you can get an existing request id
    # from these sources, in order of priority
    if env['HTTP_X_REQUEST_ID']
      request_id = env['HTTP_X_REQUEST_ID']
      Rails.logger.debug "Found HTTP_X_REQUEST_ID #{request_id}"
    elsif env['HTTP_X_AMZN_TRACE_ID']
      request_id = env['HTTP_X_REQUEST_ID'] = env['HTTP_X_AMZN_TRACE_ID'].match(/^.*Root=([^;]*).*$/).captures[0]
      Rails.logger.debug "Found HTTP_X_AMZN_TRACE_ID #{request_id}"
    end

    # if no request id is available, generate one
    if request_id.nil?
      request_id = env['HTTP_X_REQUEST_ID'] = SecureRandom.uuid
      Rails.logger.debug "Set request_id #{request_id}"
    end

    # set the request id in the request store
    # so we can use it later in the Net::HTTPHeader monkey patch
    RequestStore.store[:request_id] = request_id

    # call the superclass and get the app return values
    status, headers, response = @app.call(env)

    # set the request id in the response header
    headers['X-Request-Id'] = request_id

    # return all the values back up
    [status, headers, response]
  end
end

# monkey patch net http to inject our extra header
module Net::HTTPHeader
  alias original_initialize_http_header initialize_http_header

  def initialize_http_header(initheader)
    if RequestStore.store[:request_id]
      Rails.logger.debug "Adding X-Request-Id to outgoing header #{RequestStore.store[:request_id]}"
      initheader ||= {}
      initheader['X-Request-Id'] = RequestStore.store[:request_id]
    end
    original_initialize_http_header(initheader)
  end
end