# frozen_string_literal: true

module Decidim
  module DirectVerifications
    class PersistedInstrumenter
      def initialize(current_user)
      end

      def add_processed(type, email)
        # Create processed record (type, email, import_uuid)
        #
        # ProcessedEvent.create!(type: type, email: email, import_id: import_id)
      end

      def add_error(type, email)
        # Create error record (type, email, import_uuid)
        #
        # ErrorEvent.create!(type: type, email: email, import_id: import_id)
      end

      def processed_count(type)
        # Issue an AR count scoped by a UUID association to the specific import action
        #
        # ProcessedEvent.where(type: type, import_id: import_id).count
      end

      def errors_count(type)
        # Issue an AR count scoped by a UUID association to the specific import action
        #
        # ErrorEvent.where(type: type, import_id: import_id).count
      end

      def track(event, email, user = nil)
        if user
          add_processed event, email
          log_action user
        else
          add_error event, email
        end
      end
    end
  end
end
