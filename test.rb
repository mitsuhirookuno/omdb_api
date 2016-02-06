#!/usr/bin/env ruby
require 'faraday'
require 'json'

class OmdbApi
  def initialize
    @faraday = Faraday.new(url: 'http://www.omdbapi.com/') do |faraday|
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def run
    scrape
  end

  private

  def scrape
    response = @faraday.get do |r|
      r.url '?t=bakuman&y=2015&plot=full&r=json'
    end
    JSON.parse(response.body)
  end
end

begin
  omdb_api = OmdbApi.new
  p omdb_api.run
rescue => ex
  puts ex.message
  puts ex.backtrace.inspect
end