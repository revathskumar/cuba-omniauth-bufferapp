require 'cuba'
require "omniauth-buffer2"
require 'yaml'

config = YAML.load_file( 'config.yml' )["api"]

Cuba.use Rack::Session::Cookie, key: ENV["RACK_SESSION_KEY"] || "session key", secret: ENV["RACk_SESSION_SECRET"] || "session secret"

Cuba.use OmniAuth::Builder do
  provider :buffer, config["client_id"], config["client_secret"] , grant_type: "authorization_code"
end

Cuba.define do

  on get, "auth" do
    on ":provider/callback", param("state"), param("code")   do | provider, state, code |
      auth = env["omniauth.auth"]
      res.write "<input type='hidden' value='#{auth["credentials"]["token"]}' id='access_token'/>"
      res.write "Successfully authenticated!"
      # res.write auth["credentials"]["token"]
    end

    on "failure" do
      res.write "Buffer app Authentication failed!"
    end
  end

  on get do
    on root do
      res.write "Buffer app authentication"
    end
  end
end
