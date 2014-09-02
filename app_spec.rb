require_relative 'spec_helper'

describe CallbacksApp do
  describe "/heartbeat" do
    it "should return 200" do
      get '/heartbeat'
      expect(last_response).to be_ok
    end
  end

  context "there are no registered callbacks" do
    describe '/callbacks/:oid' do
      it "should return 404 if callbacks returns nil" do
        allow_any_instance_of(SubscriberSet).to(
           receive_message_chain(:for, :callbacks).and_return(nil))
        get '/callbacks/123'
        expect(last_response.status).to eq 404
      end
    end
  end
end
