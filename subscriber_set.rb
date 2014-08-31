# a subscriber set is a collection of callbacks and their
# details for a given object (by its unique identifier)
require 'set'

class SubscriberSet

  @@subscriptions = {}

  class << self
    def for oid
      new oid
    end
  end

  def initialize oid
    @oid = oid
  end

  def add_callback url
    if url.nil? || url.empty?
      false
    else
      self.class.add_callback @oid, url
    end
  end

  def get_callbacks
    self.class.get_callbacks @oid
  end

  def remove_callback url
    if url.nil? || url.empty?
      false
    else
      self.class.remove_callback @oid, url
    end
  end

  def delete
    self.class.delete @oid
  end

  def last_updated_at
    self.class.last_updated_at(@oid)
  end

  class << self

    def get_callbacks oid
      subscription(oid)[:callbacks].to_a
    end

    def add_callback oid, url, updated_at=Time.now.to_f
      subscription(oid)[:callbacks] << url
      set_last_updated_at oid, updated_at
      true
    end

    def remove_callback oid, url, updated_at=Time.now.to_f
      if subscription(oid)[:callbacks].delete? url
        set_last_updated_at oid, updated_at
        true
      else
        false
      end
    end

    def delete oid
      if @@subscriptions.delete oid
        true
      else
        false
      end
    end

    def last_updated_at oid
      subscription(oid)[:updated_at]
    end

    def set_last_updated_at oid, updated_at
      subscription(oid)[:updated_at] = updated_at
    end

    def subscription oid
      @@subscriptions[oid] = { callbacks: Set.new } if @@subscriptions[oid].nil?
      @@subscriptions[oid]
    end
  end

  private(:initialize)
end
