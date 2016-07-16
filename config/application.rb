require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mammoth
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # http://stackoverflow.com/questions/18934115/rails-4-organize-rails-models-in-sub-path-without-namespacing-models
    # To Add a nested model without namespace 
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    #To get the glyphicons working
    config.assets.paths << "#{Rails}/vendor/assets/fonts"
    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.autoload_paths << Rails.root.join('lib/core_extensions/**/')
    require 'core_extensions/string/to_bool'
    require 'core_extensions/integer/converter'
  end
end
