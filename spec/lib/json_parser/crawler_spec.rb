require 'spec_helper'

describe JsonParser::Crawler do
  let(:subject) do
    described_class.new path, default_options.merge(options), &block
  end
  let(:block) { proc { |v| v } }
  let(:path) { '' }
  let(:default_options) { { case_type: :lower_camel} }
  let(:options) { {} }
  let(:json) { load_json_fixture_file('json_parser.json') }
  let(:value) { subject.crawl(json) }

  context 'when parsing with a path' do
    let(:path) { %w(user name) }

    it 'retrieves attribute from base json' do
      expect(value).to eq(json['user']['name'])
    end
  end

  context 'crawler finds a nil attribute' do
    let(:path) { %w(car model) }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end

  context 'when json is empty' do
    let(:json) { nil }
    let(:path) { %w(car model) }

    it 'returns nil' do
      expect(value).to be_nil
    end

    it do
      expect { value }.not_to raise_error
    end
  end

  context 'with an snake case path' do
    let(:path) { ['has_money'] }

    it 'returns camel cased value' do
      expect(value).to eq(json['hasMoney'])
    end
  end

  context 'when dealing with json inside arrays' do
    let(:path) { %w(animals race species name)}
    let(:expected) do
      ['European squid', 'Macaque monkey', 'Mexican redknee tarantula']
    end

    it do
      expect(value).to be_a(Array)
    end

    it 'parses them mapping arrays as sub parse' do
      expect(value).to eq(expected)
    end

    context 'when there are nil values' do
      context 'with compact option as false' do
        let(:options) { { compact: false } }
        before do
          json["animals"].last['race'] = nil
        end
        let(:expected) do
          ['European squid', 'Macaque monkey', nil]
        end

        it 'eliminate nil values' do
          expect(value).to eq(expected)
        end
      end

      context 'with compact option' do
        let(:options) { { compact: true } }
        before do
          json["animals"].last['race'] = nil
        end
        let(:expected) do
          ['European squid', 'Macaque monkey']
        end

        it 'eliminate nil values' do
          expect(value).to eq(expected)
        end
      end
    end
  end

  context 'when using a snake case' do
    let(:json) { { snake_cased: 'snake', snakeCased: 'Camel' }.stringify_keys }
    let(:path) { [ 'snake_cased' ] }
    let(:options) { { case_type: :snake } }

    it 'fetches from snake cased fields' do
      expect(value).to eq('snake')
    end
  end

  context 'when using a upper camel case' do
    let(:json) { { UpperCase: 'upper', upperCase: 'lower' }.stringify_keys }
    let(:path) { [ 'upper_case' ] }
    let(:options) { { case_type: :upper_camel } }

    it 'fetches from upper camel cased fields' do
      expect(value).to eq('upper')
    end
  end

  context 'when using a symbol keys' do
    let(:json) { load_json_fixture_file('json_parser.json').symbolize_keys }
    let(:path) { [ 'id' ] }

    it 'fetches from symbol keys' do
      expect(value).to eq(json[:id])
    end

    context 'crawler finds a nil attribute' do
      let(:path) { %w(car model) }

      it 'returns nil' do
        expect(value).to be_nil
      end

      it do
        expect { value }.not_to raise_error
      end
    end
  end

  context 'when using key with false value' do
    let(:path) { ['has_money'] }
    before do
      json['hasMoney'] = false
    end

    context 'with string keys' do
      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end

    context 'with symbol keys' do
      before do
        json.symbolize_keys!
      end

      it { expect(value).to be_falsey }
      it { expect(value).not_to be_nil }
    end
  end
end
