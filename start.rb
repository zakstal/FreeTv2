$:.unshift File.dirname(__FILE__)
require 'required'
require 'web_interface_helpers'
require 'text'
require 'show'
require 'formatter'
require 'objects'
require 'displayer'
require 'controller'

include UrlHelpers
include Formats
include	Views



def do_it
		ask_what_show
		choice = gets.chomp
		get_show(choice)
		a_show = ShowName.new(choice)
		# a_show.populate
		choice_control(a_show)
	do_it
end

do_it
