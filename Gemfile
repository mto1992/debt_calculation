# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'sinatra'
gem 'sinatra-reloader'
gem "sinatra-activerecord"
#gem "sqlite3"
gem "rake"

group :production do
  gem 'pg','~>0.18.4'
end