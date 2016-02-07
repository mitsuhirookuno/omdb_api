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
      faraday.adapter  Faraday.default_adapter
    end
  end

  def by_id(id, options = {})
    scrape(@params.merge(i: id).merge(options))
  end

  def by_title(title, options = {})
    scrape(@params.merge(t: title).merge(options))
  end

  def by_search(search_word, options = {})
    scrape(@params.merge(s: search_word).merge(options))
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
  results = omdb_api.by_search('bakuman', type: 'movie')
  results['Search'].each do |result|
    p omdb_api.by_id(result['imdbID'])
  end
rescue => ex
  puts ex.message
  puts ex.backtrace.inspect
end