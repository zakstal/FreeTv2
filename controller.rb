$:.unshift File.dirname(__FILE__)
require 'web_interface_helpers'
require 'text'
require 'show'
require 'formatter'
require 'displayer'
require 'controller'

include UrlHelpers
include Formats
include	Views



def choice_control(show)
	a_show = ""
	level = 0
	index = 0
	current_show = CurrentShow.new
	current_show.show_name = show.show[:show_name]
	loop do
		display_controler(current_show,show, level, index)
		choice = gets.chomp

		case choice
		#reloads loop
		when ""
			next
		# go back to main screen
		when "m"
			level = 0
		# go back one screen
		when "b"
			if level == 0
				break
			else
				if index > 0
					index -= 10
				else
					level -= 1
				end
			end
		# shows the seasons
		when "s"
			level = 1
		# shows the epsisodes
		when "e"
			level = 2
			season = current_show.season
			a_show = show.show_episodes_from(season) if season != ""
		when "n"
			index = 10
		else
				case level
				# Main screen choices router
				when 0
					case choice

					when "1"
						break
					when "2"
						level = 1
					when "3"
						puts show.plot
						gets
					end
				# season choice rounter
				when 1
					season = show.show_seasons[choice.to_i - 1]
					current_show.season = season
					level = 2
				when 2
					ep = show.show_episodes_from(current_show.season)[choice.to_i - 1]
					current_show.episode = ep
					level = 3
				when 3
					case choice
					when "p"
						# extracts the episode number and selects the next episode
						next_ep = current_show.episode.gsub(/\D/,"")
						ep = show.show_episodes_from(current_show.season)[next_ep.to_i]
						current_show.episode = ep
					when "re"
						current_show.episode
					end

				end

		end
	end
end
