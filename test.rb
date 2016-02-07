#!/usr/bin/env ruby
require 'faraday'
require 'json'
require 'active_support'
require 'active_support/core_ext/hash'
require 'pry'

class OmdbApi

  def initialize
    @params = {}
    @faraday = Faraday.new(url: 'http://www.omdbapi.com/') do |faraday|
      # faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def by_id_and_title(options = {})
    scrape(@params.merge(options))
  end

  def by_title(options = {})
    scrape(@params.merge(options))
  end

  private

  def scrape(params)
    response = @faraday.get do |r|
      r.url "?#{params.to_query}"
    end
    JSON.parse(response.body)
  end
end

begin
  omdb_api = OmdbApi.new
  results = omdb_api.by_title( s: 'bakuman', type: 'movie')
  results['Search'].each do |result|
    p omdb_api.by_id_and_title( i: result['imdbID'])
  end
rescue => ex
  puts ex.message
  puts ex.backtrace.inspect
end