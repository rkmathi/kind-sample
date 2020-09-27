require 'json'
require 'securerandom'

UUID = SecureRandom.uuid

class RackApp
  def call(env)
    body = { uuid: UUID, env: env }
    [200, { 'Content-Type' => 'application/json' }, [body.to_json]]
  end
end

run RackApp.new
