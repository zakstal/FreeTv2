# $LOAD_PATH << File.dirname('./ifram2')
$:.unshift File.dirname(__FILE__)
require 'web_interface_helpers'
require 'text'
require 'pp'
require 'open-uri'

# ShowName class
# 	- methods
# 		- populate 				adds plot, seasons, episodes, and episode links to the object
# 		- add_show_name_url 	inserts the show title into the url then adds url to object
# 		- add_plot				add plot to the object
# 		- add_seasons			adds the seasons to the and initializes EpisodeList
# 		- add_episodes 			adds episodes to the object
# 		- show_seasons			returns an array of seasons
# 		- show_episodes_from() 	returns an array of epiodes from a specified season
#  		- play()				plays episode taking season and episode as parameter
# EpisodeList class
# 	- methods
# 		- get_episodes			populates a hash with episodes and their links initialized in Episodelinks
# EpisodeLinks class
# 	- methods
# 		- get_links_of_speed()	returns an array with urls from links that are, "Fast", "Average", or "Slow"
#  		- select_prefred_links()puts links in order of the variables in @@prefered_links and returns the first prefered link or another link if there is no prefered links available
#		- get_ifram()			parses a page and returns ifram url
# 		- play_episode			opens the browser with the iframe url link to the video player

class ShowName
	class EpisodeList
		class EpisodeLinks

			# EpisodeLinks class
			extend UrlHelpers
			attr_accessor :episode, :links
			def initialize(episode)
				@episode 	= { :episode 	=> episode
								}
				@links 		= {}
				@@prefered_links = %w[divxstage movshare  divxden allmyvideos vidbux]
			end

			def get_links_of_speed(speed)
				link_of_speed = []
				self.links.each do |key,value|
					link_of_speed << value if key.include?(speed)

				end

			end


			def get_iframe(page)
				dom = noko_parse(page)
				iframe_link = dom_css(dom,0)#.nil? ? dom_css(dom,1) : dom_css(dom,0)) #for some reasone the iframe location changes from time to time
				iframe_link
			end

			def dom_css(dom,num)
				dom.css('iframe')[num]["src"]
			end

			def link_file(ilink)
				File.open("test.html","w") do |line|
					open(ilink) do |link|
						line.write(link.read)
					end
				end

			end

			def select_prefered_links(link)
				pref_links = {}
					@@prefered_links.each do |link|
						found_link = links.select { |k,v| v.include?(link)}
							pref_links.merge!(found_link) if found_link.nil? == false
					end
				pref_links.nil? ? links.shift : pref_links.shift
			end

			def play_episode
				links = get_links_of_speed("Fast")

				first_link = select_prefered_links(links)[1]
				# open_a_page(link_file(get_iframe(first_link)))
				open_a_page(get_iframe(first_link))

				first_link
			end

		end

		# EpisodeList class
		extend UrlHelpers
		attr_accessor :season, :episodes
		def initialize(season, url)
			@season 	= { :season => season,
							:url 	=> url
						  }
			@episodes 	= {}
		end

		def get_episodes

			page = noko_parse(@season[:url])
				td_page =  parse_with(page,4)
					current_title = ''
						broken = td_page.to_s.split("Stream").uniq

				broken.each do |line|

						dom = noko_parse_two(line)
							elements = dom.at_xpath '//td'
								links = dom.xpath('//td/a/@href')[0]
									full_title = dom.xpath('//td/a/div/text()')
										title = full_title.to_s.gsub(/^.+(?=E)/, "")
									next if elements == nil
							@episodes[title.to_s] = EpisodeLinks.new(title.to_s) if title.to_s != current_title
						@episodes[title.to_s].links[elements.text.gsub(/\t/," ")] = links.to_s if elements.text.include?("#{title.to_s}")
					current_title = title.to_s
				end
		end
	end


	# ShowName class
	extend UrlHelpers
	attr_accessor :show, :plot, :seasons

	def initialize(show_name)
		@show 		= { :show_name 	=> show_name,
						:show_url 	=> "url"
					  }
		@plot 		= ""
		@seasons 	= {}
		populate

	end

	def populate
		add_show_name_url
		add_plot
		add_seasons
		add_episodes
	end


	def add_show_name_url

		name = @show[:show_name]

		if name.include?(" ")
			term = name.gsub!(/\W/,"_")
		else
			term = name
		end
		@show[:show_url] = "http://www.free-tv-video-online.me/internet/#{term}/"

	end

	def add_plot
		html = noko_parse(@show[:show_url])
			@plot = parse_with(html,2)
	end

	def add_seasons
		html_path = @show[:show_url]
			page = noko_parse(html_path)
				broken =  parse_with(page,3).to_s.split(" ").uniq

			broken.each do |line|

				if line.include?('season')

					season_single = line.scan(/(?<=").*(?=")/)
						url = html_path + season_single.join
							season = season_single.join.gsub(/.html/,"")
					@seasons[season] = EpisodeList.new(season,url) if !season_single.empty?
				end
			end
      # puts "all seasons: #{@seasons}"
	end

	def add_episodes
			@seasons.values.each{|each_season| each_season.get_episodes}
	end

#>>>>>>>>>>>>>>   show    >>>>>>>>>>>>>>>

	def show_episodes_from(season)
		@seasons["#{season}"].episodes.keys
	end

	def show_seasons
		@seasons.values.map{|n| n.season[:season]}
	end

	def show_link_info(season,episode)
		@seasons["#{season}"].episodes["#{episode}"]

	end

	def play(season, episode)
			@seasons[season].episodes[episode].play_episode
	end
end



class CurrentShow
	attr_accessor :show_name,:season, :episode

end
