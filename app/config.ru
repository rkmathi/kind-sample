require 'json'
require 'securerandom'

UUID = SecureRandom.uuid

class RackApp
  def call(env)
    [200, { 'Content-Type' => 'text/plain' }, ["uuid:#{UUID}\nenv:#{JSON.pretty_generate(env)}"]]
  end
end

run RackApp.new
