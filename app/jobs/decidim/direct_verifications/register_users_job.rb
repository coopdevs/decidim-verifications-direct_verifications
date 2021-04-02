# frozen_string_literal: true

require "decidim/direct_verifications/instrumenter"

module Decidim
  module DirectVerifications
    class FakeSession < Hash
    end

    class RegisterUsersJob < ApplicationJob
      queue_as :default

      def perform(userslist, organization_id, user_id)
        @userslist = userslist
        @organization = Organization.find_by(id: organization_id)
        @current_user = User.find_by(id: user_id)
        @instrumenter = PersistedInstrumenter.new(current_user)
        @session = FakeSession.new

        processor.register_users
      end

      private

      attr_reader :userslist, :organization, :current_user, :instrumenter, :session

      def processor
        @processor ||=
          begin
            processor = UserProcessor.new(organization, current_user, session, instrumenter)
            processor.emails = Verification::MetadataParser.new(userslist).to_h
            processor.authorization_handler = :direct_verifications
            processor
          end
      end
    end
  end
end
