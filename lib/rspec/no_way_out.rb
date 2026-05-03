require_relative "no_way_out/version"

module RSpec
  module NoWayOut
    ExitCalled = Class.new(StandardError)
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    exit_call = catch(:no_way_out) do
      example.run
      nil
    end
    raise RSpec::NoWayOut::ExitCalled, "exit(#{exit_call[:code]}) called at #{exit_call[:location]}" if exit_call
  end

  config.before(:each) do
    allow_any_instance_of(Object).to receive(:exit) do |_obj, code = 0|
      location = caller.find { |l| !l.include?("/gems/") }
      throw :no_way_out, {method: :exit, code: code, location: location}
    end
  end
end
