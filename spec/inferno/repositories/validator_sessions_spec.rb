RSpec.describe Inferno::Repositories::ValidatorSessions do
  let(:repo) { described_class.new }
  let(:validator_name) { 'basic_name' }
  let(:test_suite_id) { 'basic_suite' }
  let(:first_validator_session_id) { 'basic_validator1' }
  let(:second_validator_session_id) { 'basic_validator2' }
  let(:third_validator_session_id) { 'basic_validator3' }
  let(:first_suite_options) { { ig_version: '1', us_core_version: '4' } }
  let(:second_suite_options) { { ig_version: '2' } }
  let(:suite_options_alt) { { us_core_version: '4', ig_version: '1' } }
  let(:session1_params) do
    {
      validator_session_id: first_validator_session_id,
      validator_name:,
      test_suite_id:,
      suite_options: first_suite_options
    }
  end
  let(:session2_params) do
    {
      validator_session_id: second_validator_session_id,
      validator_name:,
      test_suite_id:,
      suite_options: second_suite_options
    }
  end
  let(:session3_params) do
    {
      validator_session_id: third_validator_session_id,
      validator_name:,
      test_suite_id:,
      suite_options: first_suite_options
    }
  end
  let(:session_params_alt_options) do
    {
      validator_session_id: second_validator_session_id,
      validator_name:,
      test_suite_id:,
      suite_options: suite_options_alt
    }
  end
  let(:session_params_alt_name) do
    {
      validator_session_id: second_validator_session_id,
      validator_name: 'alt name',
      test_suite_id:,
      suite_options: first_suite_options
    }
  end
  let(:session_params_alt_id) do
    {
      validator_session_id: second_validator_session_id,
      validator_name:,
      test_suite_id: 'alt id',
      suite_options: first_suite_options
    }
  end

  describe '#create' do
    before do
      repo.save(session1_params)
    end

    context 'with valid params' do
      it 'persists data' do
        record = repo.db.first
        expect(repo.db.count).to eq(1)
        expect(record[:validator_session_id]).to eq(first_validator_session_id)
        expect(record[:validator_name]).to eq(validator_name)
        expect(record[:test_suite_id]).to eq(test_suite_id)
      end

      it 'creates a separate record given a different validator session id' do
        repo.save(session2_params)
        record = repo.db.all[1]
        expect(repo.db.count).to eq(2)
        expect(record[:validator_session_id]).to eq(second_validator_session_id)
        expect(record[:validator_name]).to eq(validator_name)
        expect(record[:test_suite_id]).to eq(test_suite_id)
      end

      it 'overwrites an existing record given the same validator session id' do
        repo.save(session3_params)
        record = repo.db.first
        expect(repo.db.count).to eq(1)
        expect(record[:validator_session_id]).to eq(third_validator_session_id)
        expect(record[:validator_name]).to eq('basic_name')
        expect(record[:test_suite_id]).to eq(test_suite_id)
      end
    end
  end

  describe '#find' do
    before do
      repo.save(session1_params)
    end

    context 'with valid params' do
      it 'finds a single record' do
        record = repo.db.first
        validator_id = repo.find_validator_session_id(session1_params[:test_suite_id],
                                                      session1_params[:validator_name],
                                                      session1_params[:suite_options])
        expect(record[:validator_session_id]).to eq(validator_id)
      end

      it 'updates validator session id when reverse order suite options cause overwrite' do
        repo.save(session_params_alt_options)
        record = repo.db.first
        validator_id = repo.find_validator_session_id(session1_params[:test_suite_id],
                                                      session1_params[:validator_name],
                                                      session1_params[:suite_options])
        validator_id_alt = repo.find_validator_session_id(session_params_alt_options[:test_suite_id],
                                                          session_params_alt_options[:validator_name],
                                                          session_params_alt_options[:suite_options])
        expect(second_validator_session_id).to eq(validator_id)
        expect(second_validator_session_id).to eq(validator_id_alt)
        expect(second_validator_session_id).to eq(record[:validator_session_id])
      end

      it 'saves two records and finds the correct one, discriminating by suite options' do
        repo.save(session2_params)
        record = repo.db.first
        record2 = repo.db.all[1]
        validator_id = repo.find_validator_session_id(session1_params[:test_suite_id],
                                                      session1_params[:validator_name],
                                                      session1_params[:suite_options])
        validator_id2 = repo.find_validator_session_id(session2_params[:test_suite_id],
                                                       session2_params[:validator_name],
                                                       session2_params[:suite_options])
        expect(record[:validator_session_id]).to eq(validator_id)
        expect(record2[:validator_session_id]).to eq(validator_id2)
      end

      it 'saves two records and finds the correct one, discriminating by validator name' do
        repo.save(session_params_alt_name)
        record = repo.db.first
        record2 = repo.db.all[1]
        validator_id = repo.find_validator_session_id(session1_params[:test_suite_id],
                                                      session1_params[:validator_name],
                                                      session1_params[:suite_options])
        validator_id2 = repo.find_validator_session_id(session_params_alt_name[:test_suite_id],
                                                       session_params_alt_name[:validator_name],
                                                       session_params_alt_name[:suite_options])
        expect(record[:validator_session_id]).to eq(validator_id)
        expect(record2[:validator_session_id]).to eq(validator_id2)
      end

      it 'saves two records and finds the correct one, discriminating by suite id' do
        repo.save(session_params_alt_id)
        record = repo.db.first
        record2 = repo.db.all[1]
        validator_id = repo.find_validator_session_id(session1_params[:test_suite_id],
                                                      session1_params[:validator_name],
                                                      session1_params[:suite_options])
        validator_id2 = repo.find_validator_session_id(session_params_alt_id[:test_suite_id],
                                                       session_params_alt_id[:validator_name],
                                                       session_params_alt_id[:suite_options])
        expect(record[:validator_session_id]).to eq(validator_id)
        expect(record2[:validator_session_id]).to eq(validator_id2)
      end
    end
  end
end
