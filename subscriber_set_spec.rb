require_relative 'subscriber_set'
require 'timecop'

describe SubscriberSet do
  let(:oid) { '1' }
  let(:test_set) { ss = SubscriberSet.for oid }
  let(:callback_urls) { [] }

  before do
    callback_urls.each { |callback_url| test_set.add_callback callback_url }
  end

  after do
    SubscriberSet.class_variable_set :@@subscriptions, {}
  end

  it "adds callbacks to the set" do
    expect { test_set.add_callback 'http://blah.com' }.not_to raise_error
  end

  context "no callbacks added" do
    context "#get_callbacks" do
      let(:callback_urls) { [] }
      it "returns blank array" do
        expect(test_set.get_callbacks).to eq []
      end
    end
  end

  context "multiple callbacks added" do
    let(:callback_urls) { ['http://www.example.com/here?test=1',
                           'https://otherexample.org?take=2',
                           'http://here.there.and.biz/take?key=212'] }

    context "#get_callbacks" do
      it "returns all the added callbacks" do
        expect(test_set.get_callbacks).to eq callback_urls
      end
    end

    context "#remove_callback" do
      it "can remove a single callback" do
        test_set.remove_callback callback_urls.first
        expect(test_set.get_callbacks).to eq callback_urls[1..-1]
      end
    end

    context "#last_updated_at" do
      before { Timecop.freeze }
      after { Timecop.return }

      it "returns the integer time of the last added callback" do
        test_set.add_callback callback_urls.first
        start = Time.now
        Timecop.freeze(start+10)
        expect(test_set.last_updated_at).to eq start.to_f
      end

      it "returns the interger time of the last remove callback" do
        test_set.add_callback callback_urls.first
        start = Time.now
        Timecop.freeze(start+10)
        expect(test_set.last_updated_at).to eq start.to_f
      end

      it "returns nil after a delete" do
        test_set.delete
        start = Time.now
        Timecop.freeze(start+10)
        expect(test_set.last_updated_at).to eq nil
      end
    end

    context "#delete" do
      it "removes all callbacks" do
        test_set.delete
        expect(test_set.get_callbacks).to eq []
      end
    end
  end
end
