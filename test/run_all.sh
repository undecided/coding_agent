#!/bin/bash

cd $(dirname "$0/..")

bundle exec ruby -Ilib -e 'ARGV.each { |f| require f }' ./test/*_test.rb
