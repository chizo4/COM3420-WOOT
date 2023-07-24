# This class lets us subscribe to message notifications
# that are published on a given channel. This lets
# multiple clients subscribe to the same channel and they
# all receive that message when a message is published
# to that channel.

# It uses a postgresql pub/sub mechanism to achieve this.
class PgPubsub
  # initialize the class with the channel name provided as a string
  def initialize(channel)
    @channel = channel
  end

  # subscribe to this channel. This method should have a block
  # passed to it that is then called when a message is received
  # from the channel.
  def subscribe
    with_subscriptions_connection do |connection|
      connection.exec "LISTEN #{@channel}" # listen to messages on that channel
      loop do
        connection.wait_for_notify(1) do |event, id, data| # wait for a message
          yield data # call the block passed into this method
        end
      end
      ensure
        connection.exec "UNLISTEN #{@channel}"
    end
  end

  # publish a message to the channel. This takes a string message
  # which should in most cases contain json to be used in your frontend
  # JavaScript
  def publish(json)
    with_broadcast_connection do |connection|
      connection.exec "NOTIFY #{@channel}, '#{connection.escape_string json}'"
    end
  end

  private
    def with_subscriptions_connection(&block)
      ar_conn = ActiveRecord::Base.connection_pool.checkout.tap do |conn|
        ActiveRecord::Base.connection_pool.remove(conn)
      end
      pg_conn = ar_conn.raw_connection

      yield pg_conn
    ensure
      ar_conn.disconnect!
    end

    def with_broadcast_connection(&block)
      ActiveRecord::Base.connection_pool.with_connection do |ar_conn|
        pg_conn = ar_conn.raw_connection
        yield pg_conn
      end
    end
end
