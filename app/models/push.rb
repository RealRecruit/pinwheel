class Push
  def self.deliver(user:, title:, body:)
    user.devices.map do |device|
      Rails.logger.info "[Push] #{device.platform} device=#{device.id} user=#{user.id} title=#{title.inspect}"
      user.push_deliveries.create!(device: device, title: title, body: body, delivered_at: Time.current)
    end
  end
end
