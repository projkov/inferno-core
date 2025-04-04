require 'request_helper'

RSpec.describe 'client requests' do
  let(:router) { Inferno::Web::Router }

  describe 'GET /test_sessions/:id' do
    it 'returns a 404 if no session is found' do
      get router.path(:client_session_show, id: SecureRandom.uuid)

      expect(last_response.status).to eq(404)
    end

    it 'redirects to /:test_suite_id/:id if the session is found' do
      session = repo_create(:test_session)
      get router.path(:client_session_show, id: session.id)

      expected_path = Inferno::Application['inferno_host'] +
                      router.path(:client_suite_session_show, id: session.id, test_suite_id: session.test_suite_id)

      expect(last_response.status).to eq(302)
      expect(last_response.headers['Location']).to eq(expected_path)
    end
  end

  describe 'GET /:test_suite_id/:id' do
    it 'returns a 404 if no session is found' do
      get router.path(:client_suite_session_show, id: SecureRandom.uuid, test_suite_id: 'basic')

      expect(last_response.status).to eq(404)
    end

    it 'returns a 404 if no suite is found' do
      session = repo_create(:test_session)

      allow_any_instance_of(Inferno::Entities::TestSession).to receive(:test_suite_id).and_return('bad_suite')

      get router.path(:client_suite_session_show, id: session.id, test_suite_id: 'bad_suite')

      expect(last_response.status).to eq(404)
    end

    it 'redirects to the sessions suite if the wrong suite id is used' do
      session = repo_create(:test_session)
      get router.path(:client_suite_session_show, id: session.id, test_suite_id: 'demo')

      expected_path = Inferno::Application['inferno_host'] +
                      router.path(:client_suite_session_show, id: session.id, test_suite_id: session.test_suite_id)

      expect(last_response.status).to eq(302)
      expect(last_response.headers['Location']).to eq(expected_path)
    end

    it 'returns a 200 if the session and suite are found' do
      session = repo_create(:test_session)
      get router.path(:client_suite_session_show, id: session.id, test_suite_id: session.test_suite_id)

      expect(last_response.status).to eq(200)
    end
  end
end
