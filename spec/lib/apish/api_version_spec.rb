require 'spec_helper'

describe Apish::ApiVersion do

  before :each do
    configure_apish
  end

  let :v1_accepts do
    'application/vnd.some-app-v1+json'
  end

  let :v2_accepts do
    'application/vnd.some-app-v2+json'
  end

  describe "#max" do

    subject do
      described_class.new( v1_accepts ).max
    end

    it { should == 1 }

  end

  describe "#to_s" do

    subject do
      described_class.new( v1_accepts ).to_s
    end

    it { should == '1' }

  end

  describe "#to_i" do

    subject do
      described_class.new( v2_accepts ).to_i
    end

    it { should == 2 }

  end

  describe "#exists?" do

    context 'when the verison is 1' do

      subject do
        described_class.new( v1_accepts ).exists?
      end

      it { should be_true }

    end

    context 'when the verison is 2' do

      subject do
        described_class.new( v2_accepts ).exists?
      end

      it { should be_false }

    end

  end

  describe "#most_recent?" do

    before :each do
      version.stub!( :max ).and_return 2
    end

    subject do
      version.most_recent?
    end

    context 'when the verison is 1' do

      let :version do
        described_class.new v1_accepts
      end

      it { should be_false }

    end

    context 'when the verison is 2' do

      let :version do
        described_class.new v2_accepts
      end

      it { should be_true }

    end

  end

end
