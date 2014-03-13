# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'shows/version'

Gem::Specification.new do |s|
    s.name = "shows"
    s.version = Shows::VERSION
    s.authors = ["Julien Leicher"]
    s.email = ["jleicher@gmail.com"]
    s.homepage = ""
    s.summary = "A cli application to follow TV show releases"
    s.description = "A cli application to follow TV show releases!"

    s.rubyforge_project = "shows"

    s.files = Dir['README.md', 'lib/**/*', 'bin/**/*']
    s.executables = ['shows']
end