require 'oauth2/strategy/base'

# Retrieve an access token given the specified validation code.
#
# @param [String] code The Authorization Code value
# @param [Hash] params additional params
# @param [Hash] opts options
# @note that you must also provide a :redirect_uri with most OAuth 2.0 providers
module OAuth2
  module Strategy
    class AuthCode  < Base
      def get_token(code, params = {}, opts = {})
        params['redirect_uri'] = params['redirect_uri'].split('?').first if params.has_key? 'redirect_uri'
        params = {
            'grant_type' => 'authorization_code',
            'code' => code
        }.merge(client_params).merge(params)
        @client.get_token(params, opts)
      end
    end
  end
end