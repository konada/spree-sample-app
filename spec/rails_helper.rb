ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'database_cleaner'
require 'rspec/active_job'

include Warden::Test::Helpers
Warden.test_mode!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/factories'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/flash'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/caching'

require 'spree/api/testing_support/caching'
require 'spree/api/testing_support/helpers'
require 'spree/api/testing_support/setup'

require 'vcr'
require 'webmock/rspec'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/rails'

Capybara.save_path = ENV.fetch('CIRCLE_ARTIFACTS', Rails.root.join('tmp/capybara')).to_s
Capybara::Screenshot.prune_strategy = { keep: 20 }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.infer_spec_type_from_file_location!

  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:spree_user]
  end

  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::Flash

  config.include Spree::Api::TestingSupport::Helpers, type: :controller
  config.extend Spree::Api::TestingSupport::Setup, type: :controller

  config.before :each do
    reset_spree_preferences do |config|
      config.default_country_id = FactoryBot.create(:country).id
    end
  end

  config.include Devise::TestHelpers, type: :controller

  config.include Warden::Test::Helpers
  config.before :suite do
    Warden.test_mode!
  end
end
