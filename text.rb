require 'formatter'

module Views

	def ask_what_show
		spacer(14)
		puts "\twhat show would you like to see?"
		spacer(10)
	end

	def main_screen
		["Find a new show","see all seasons","see plot"]
	end

	def option_choice
		puts "choose an option"
	end

	def options
		"||>> m - main, b - back, s - season "
	end
	def nextt
		", n - next"
	end

	def getting
		puts "\t\tgetting episode.........."
	end

	def get_show(show)
		puts "\t\tgetting #{show}.........."
	end

	def playme
		", p - play next episode"
	end

	def reloadd
		", re - reload with another player"
	end
end
