$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "../lib/diagram_factory_impl"
require 'node'
require 'node_diagram_impl'
require "minitest/autorun"
