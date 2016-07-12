require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Meetup < OmniAuth::Strategies::OAuth2
      option :name, "meetup"

      option :client_options, {
        :site => 'https://api.meetup.com',
        :authorize_url => 'https://secure.meetup.com/oauth2/authorize',
        :token_url => 'https://secure.meetup.com/oauth2/access'
      }

      option :scope, true
      # see http://www.meetup.com/de-DE/meetup_api/auth/#messaging_scope
      SCOPES = [:ageless, :basic, :group_edit, :group_content_edit, :messaging]
      option :authorize_options, {
          scope: SCOPES.join('+')
      }

      def request_phase
        super
      end

      uid{ raw_info['id'] }

      info do
        {
          :id => raw_info['id'],
          :name => raw_info['name'],
          :photo_url => (raw_info.key?('photo') ? raw_info['photo']['photo_link'] : nil),
          :image => (raw_info.key?('photo') ? raw_info['photo']['photo_link'] : nil),
          :urls => { :public_profile => raw_info['link'] },
          :description => raw_info['bio'],
          :location => [raw_info['city'], raw_info['state'], raw_info['country']].reject{|v| !v || v.empty?}.join(', ')
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= JSON.parse(access_token.get('/2/member/self').body)
      end

    end
  end
end
