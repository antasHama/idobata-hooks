describe Idobata::Hook::Coveralls, type: :hook do
  let(:payload) { fixture_payload("coveralls/#{fixture}.txt") }

  before do
    post payload, 'Content-Type' => 'application/x-www-form-urlencoded'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'coverage increased' do
      let(:fixture) { 'increased' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <a href='https://example.io/builds/987654321'>gihub-user/repo-name</a>
        coverage increased
        <span class='badge progress-bar-success'>3.50</span>
        to
        <span class='label label-info'>99.35%</span>
        on branch-name (<a href='https://example.io/builds/987654321'>detail</a>)
      </p>
      <p>
        commit message by Committer Name
      </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'coverage decreased' do
      let(:fixture) { 'decreased' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <a href='https://example.io/builds/987654321'>gihub-user/repo-name</a>
        coverage decreased
        <span class='badge progress-bar-danger'>-0.80</span>
        to
        <span class='label label-info'>88.19%</span>
        on branch-name (<a href='https://example.io/builds/987654321'>detail</a>)
      </p>
      <p>
        commit message by Committer Name
      </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'same coverage' do
      let(:fixture) { 'same' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <a href='https://example.io/builds/987654321'>gihub-user/repo-name</a>
        coverage remained the same at
        <span class='label label-info'>100.00%</span>
        on branch-name (<a href='https://example.io/builds/987654321'>detail</a>)
      </p>
      <p>
        commit message by Committer Name
      </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'ambiguous coverage' do
      let(:fixture) { 'ambiguous' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <a href='https://example.io/builds/987654321'>gihub-user/repo-name</a>
        coverage remained the same at
        <span class='label label-info'>0.00%</span>
        on branch-name (<a href='https://example.io/builds/987654321'>detail</a>)
      </p>
      <p>
        commit message by Committer Name
      </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
