require 'rails_helper'

RSpec.describe AuthService do
  let(:travel_time) { Time.local(2017, 4, 10, 10, 5, 0) }
  let(:data) { 'secret_data' }
  let(:encoded_data) { 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoic2VjcmV0X2RhdGEiLCJleHAiOjE0OTE4MDg4MDB9.6Nppq9c5raJ1td-CwjTWi2F0ZnRWowiZpKZkzgo1_DI' }

  describe ".encode" do
    it 'should encode data with expiration time' do
      travel_to travel_time do
        token = AuthService.encode(data)
        expect(token).to eq(encoded_data)
      end
    end
  end

  describe ".decode" do
    it 'should decode and return data if token was not expire' do
      travel_to travel_time do
        decoded_data = AuthService.decode(encoded_data)
        expect(decoded_data).to eq(data)
      end
    end

    it 'should raise exception if token was expired' do
      travel_to travel_time + 16.minutes do
        expect { AuthService.decode(encoded_data) }.to raise_error(JWT::ExpiredSignature)
      end
    end
  end
end
