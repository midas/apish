require 'spec_helper'

describe Apish::FormatResolver do

  before :each do
    configure_apish
  end

  let :no_format_accept do
    nil
  end

  let :json_format_accept do
    'application/vnd.some-app-v1+json'
  end

  describe "#format" do

    context 'when a format is provided but no current format is provided' do

      subject do
        described_class.new( json_format_accept ).format
      end

      it { should be_a( String ) }

      it { should == Mime::JSON.symbol.to_s }

    end

    context 'when the format is not set from the URL extension' do

      context 'and the format is provided in the accept header' do

        subject do
          described_class.new( json_format_accept,
                               Mime::ALL ).format
        end

        it { should be_a( String ) }

        it { should == Mime::JSON.symbol.to_s }

      end

      context 'and the format is not provided in the accept header' do

        subject do
          described_class.new( no_format_accept,
                               Mime::ALL ).format
        end

        it { should be_a( String ) }

        it { should == Mime::ALL.symbol.to_s }

      end

    end

    context 'when the format is set from the URL extension' do

      context 'and the format is provided in the accept header' do

        subject do
          described_class.new( json_format_accept,
                               Mime::XML ).format
        end

        it { should be_a( String ) }

        it { should == Mime::XML.symbol.to_s }

      end

      context 'and the format is not provided in the accept header' do

        subject do
          described_class.new( no_format_accept,
                               Mime::XML ).format
        end

        it { should be_a( String ) }

        it { should == Mime::XML.symbol.to_s }

      end

    end

    context 'when the format is incorrectly set from the vnd.* header' do

      subject do
        described_class.new( json_format_accept,
                             Mime::Type.new( 'application/vnd.some-app-v1+json' ) ).format
      end

      it { should be_a( String ) }

      it { should == Mime::JSON.symbol.to_s }

    end

  end

end
