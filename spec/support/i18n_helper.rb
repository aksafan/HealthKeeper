# frozen_string_literal: true

module I18nHelper
  def t(key, **)
    I18n.t(key, **)
  end
end

RSpec.configure do |config|
  config.include I18nHelper
end
