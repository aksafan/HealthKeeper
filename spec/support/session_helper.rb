# frozen_string_literal: true

module SessionHelper
  def inject_session(session_data = {})
    { 'rack.session' => session_data }
  end
end

RSpec.configure do |config|
  config.include SessionHelper, type: :request
end
