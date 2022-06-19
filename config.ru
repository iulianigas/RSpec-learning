# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require 'D:\Rspec_Learning\test_app\spec\chapter_4\app\api.rb'
run ExpenseTracker::API.new

run Rails.application
Rails.application.load_server
