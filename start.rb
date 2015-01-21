$:.unshift File.dirname(__FILE__)
require 'web_interface_helpers'
require 'text'
require 'show'
require 'formatter'
# require 'objects'
require 'displayer'
require 'controller'

include UrlHelpers
include Formats
include	Views



def do_it
		puts "\e[H\e[2J"
		ask_what_show
		choice = gets.chomp
		get_show(choice)
		a_show = ShowName.new(choice)
		# a_show.populate
		if a_show.plot == ""
			sorry
			gets
		else
			choice_control(a_show)
		end
	do_it
end

do_it
