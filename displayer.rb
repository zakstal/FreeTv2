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

def display_controler(current_show, a_show, levels, index)
	i = index

case levels
				# a_shows the main screen
				when 0
						name = a_show.show[:show_name]
						screen(["welcome!",name],[1,main_screen],[])

				# season choice screen
				when 1
					name = current_show.show_name
					sea = a_show.show_seasons

					screen([name],[i+1,sea[i,10]],[options + nextt])

				# episode choice screen
				when 2
					name = current_show.show_name
					sea = current_show.season
					episodes = a_show.show_episodes_from(sea)[i..i+10]

					screen([name,sea],[i+1,episodes],[options + nextt])
				# link info display screen
				when 3
					name = current_show.show_name
					sea = current_show.season
					ep = current_show.episode
					getting
					#plays episode and returns the link
					begin
						link_info = a_show.play(sea,ep)
					ensure
						info = a_show.seasons[sea].episodes[ep].links.key(link_info)
					end

					screen([name,sea,ep],["s",info],[options + playme])

			end

end
