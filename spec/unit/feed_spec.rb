# frozen_string_literal: true
require 'spec_helper'
require 'rspec/collection_matchers'
require 'webmock/rspec'

WebMock.disable_net_connect!

describe Concourse::Resource::RSS::Feed do
  subject { Concourse::Resource::RSS::Feed.new(url) }
  let(:url) { 'https://www.postgresql.org/versions.rss' }

  before do
    stub_request(:get, url).to_return(
      status: 200,
      body: File.read(fixture('feed/postgres-versions.rss'))
    )
  end

  it 'has the title' do
    expect(subject.title).to eq('PostgreSQL latest versions')
  end

  it 'has the last build date' do
    expect(subject.last_build_date).to eq(Time.parse('Thu, 27 Oct 2016 00:00:00 +0000'))
  end

  it 'has a number of items' do
    expect(subject.items).to_not be_empty
    expect(subject.items).to have(20).items
  end

  it 'has a first item with title' do
    first = subject.items.first
    expect(first.title).to eq('9.6.1')
  end

  it 'has a first item with link' do
    first = subject.items.first
    expect(first.link).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
  end

  it 'has a first item with description' do
    first = subject.items.first
    expect(first.description).to eq('9.6.1 is the latest release in the 9.6 series.')
  end

  it 'has a first item with pubDate' do
    first = subject.items.first
    expect(first.pubDate).to eq(Time.parse('Thu, 27 Oct 2016 00:00:00 +0000'))
  end

  it 'has a first item with guid' do
    first = subject.items.first
    expect(first.guid).to eq('https://www.postgresql.org/docs/9.6/static/release-9-6-1.html')
  end
end
