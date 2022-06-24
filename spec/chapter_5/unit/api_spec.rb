require 'D:\Rspec_Learning\test_app\spec\chapter_4\app\api'
require 'rack/test'
require 'D:\Rspec_Learning\test_app\spec\chapter_5\ledger'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods
    
    def app 
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger' )}

    describe "POST /expenses" do
      context 'when the expense is successfully recorded' do 
        let(:expense) { { 'some' => 'data' } }

        before do 
          allow(ledger).to receive(:record)  #allow method from rspec-mocks
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do 
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (ok)' do 
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do 
        let(:expense) { { 'some' => 'data' } }
        
        before do 
          allow(ledger).to receive(:record)  #allow method from rspec-mocks
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do 
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (unprocessable entity)' do 
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe "GET /expenses/:date" do
      context 'when expenses exist on the given date' do 
        before do 
          allow(ledger).to receive(:expenses_on)  #allow method from rspec-mocks
            .with('2017-06-12')
            .and_return(['expense_1'])
        end

        it 'returns the expense records as JSON' do 
          get '/expenses/2017-06-12'

          parsed = JSON.parse(last_response.body)
          expect(parsed).to eq(['expense_1'])
        end

        it 'responds with a 200 (ok)' do 
          get '/expenses/2017-06-12'

          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do 
        before do 
          allow(ledger).to receive(:expenses_on)  #allow method from rspec-mocks
            .with('2017-06-12')
            .and_return([])
        end

        it 'returns an empty array as JSON' do 
          get '/expenses/2017-06-12'

          parsed = JSON.parse(last_response.body)
          expect(parsed).to eq([])
        end

        it 'responds with a 200 (ok)' do 
          get '/expenses/2017-06-12'

          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end

#test HTTP requests to the API class