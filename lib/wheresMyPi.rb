require 'sinatra/base'
require 'tilt/erubis'
require 'json'
require 'yaml'

require_relative 'wheresMyPi/helpers'
require_relative 'wheresMyPi/racks'

module WheresMyPi
  class App < Sinatra::Base
    helpers do
      include WheresMyPi::Helpers
    end

    PI_RACK = {}

    get '/' do
      headers 'Vary' => 'Accept'

      respond_to do |wants|
        wants.html do
          @content = "<h1>Raspis we've heard from recently</h1>"
          @title = 'WheresMyPi'
          @github_url = CONFIG['github_url']
          erb :index, layout: :default
        end

        wants.json do
          {
            app: 'WheresMyPi'
          }.to_json
        end
      end
    end

    get '/:pi_name/:pi_ip' do
      PI_RACK[params[:pi_name]] = params[:pi_ip]
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
