# frozen_string_literal: true

module Decidim
  module DirectVerifications
    module Verification
      module Admin
        class ImportsController < Decidim::Admin::ApplicationController
          def new
            enforce_permission_to :create, :authorization
          end

          def create
            enforce_permission_to :create, :authorization

            defaults = { organization: current_organization, user: current_user }
            form = form(CreateImportForm).from_params(params.merge(defaults))

            CreateImport.call(form) do
              on(:ok) do
                flash[:notice] = t(".success")
              end

              on(:invalid) do
                flash[:alert] = t(".error")
              end
            end

            redirect_to new_import_path
          end
        end
      end
    end
  end
end
