require 'cuba'
require "omniauth-buffer2"

Cuba.use Rack::Session::Cookie, key: ENV["RACK_SESSION_KEY"] || "session key", secret: ENV["RACk_SESSION_SECRET"] || "session secret"

Cuba.use OmniAuth::Builder do
  provider :buffer, "__your_client_id__", "__your_client_secret__ ", grant_type: "authorization_code"
end

Cuba.define do

  on get, "auth" do
    on ":provider/callback", param("state"), param("code")   do | provider, state, code |
      auth = env["omniauth.auth"]
      res.write auth["credentials"]["token"]
    end

    on "failure" do
      res.write "auth_failure"
    end
  end

  on get do
    on root do
      res.write "Buffer app authentication"
    end
  end
end
