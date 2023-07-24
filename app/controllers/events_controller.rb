# frozen_string_literal: true

class EventsController < ActionController::Base
  include ActionController::Live

  def index
    request.env['rack.hijack'].call
    stream = request.env['rack.hijack_io']
    send_headers(stream)

    Thread.new do
      stream_data(stream)
    end

    response.close
  end

  private

  def stream_data(stream)
    sse = SSE.new(stream, retry: 300, event: 'update')

    PgPubsub.new('event').subscribe do |data|
      sse.write(data)
      stream.flush
    end
  rescue ActionController::Live::ClientDisconnected
  rescue Errno::EPIPE
  ensure
    sse.close
  end

  def send_headers(stream)
    headers = [
      'HTTP/1.1 200 OK',
      'Content-Type: text/event-stream'
    ]

    stream.write(headers.map { |header| "#{header}\r\n" }.join)
    stream.write("\r\n")
    stream.flush
  rescue StandardError
    stream.close
    raise
  end
end
