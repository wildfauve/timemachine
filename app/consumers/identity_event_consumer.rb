class IdentityEventConsumer < Racecar::Consumer
  subscribes_to "io.mindainfo.identity.identity_subject"

  def process(message)
    puts "KAFKA ====> Received message: #{message.value}"
  end
end
