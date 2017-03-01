require "spec_helper"

describe API::V3::Services, api: true  do
  include ApiHelpers

  let(:user) { create(:user) }
  let(:project) { create(:empty_project, creator_id: user.id, namespace: user.namespace) }

  Service.available_services_names.each do |service|
    describe "DELETE /projects/:id/services/#{service.dasherize}" do
      include_context service

      it "deletes #{service}" do
        delete v3_api("/projects/#{project.id}/services/#{dashed_service}", user)

        expect(response).to have_http_status(200)
        project.send(service_method).reload
        expect(project.send(service_method).activated?).to be_falsey
      end
    end
  end
end