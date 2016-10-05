class ConnectedList
  CONNECTED_EMAILS = 'connected_emails'

  def self.redis
    #@redis ||= Redis.new(url: "redis://localhost:6379/cable")
    @redis ||= Redis.new(url: "redis://redistogo:dfc085ee6a422a8b33171254c32bf7df@sculpin.redistogo.com:10151/cable")

    #::Redis.new(url: ActionCableConfig[:url])
  end

  def self.all
    redis.zrange(CONNECTED_EMAILS, 0, -1)
  end

  def self.add(email)
    redis.zadd(CONNECTED_EMAILS, 1, email)
    if redis.hgetall("appearance|#{email}")["status"]
    else
      redis.hset("appearance|#{email}", "status", "Online")
    end
  end

  def self.remove(email)
    redis.zrem(CONNECTED_EMAILS, email)
    redis.del("appearance|#{email}")
  end

  def self.change_status(email, status)
    redis.hset("appearance|#{email}", "status", status)
  end

  def self.retrieve_status(email)
    redis.hgetall("appearance|#{email}")["status"]
  end

  def self.delete_status(email)
    redis.del("appearance|#{email}")
  end

  def self.clear_all
    redis.del(CONNECTED_EMAILS)
  end

  # def self.include?(uid)
  #   redis.sismember(CONNECTED_EMAILS_KEY, uid)
  # end
end
