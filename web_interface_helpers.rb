$:.unshift File.dirname(__FILE__)
require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'

module UrlHelpers

 	def noko_parse(html_path)
		Nokogiri::HTML(open(html_path))
	end

	def noko_parse_two(line)
		Nokogiri.HTML(line)
	end

	def open_a_page(page)
		begin
		# browser = Watir::Browser.new
		# browser.goto page
		# #`start #{page}`
    `open #{page}`
		rescue "well try this again"

		end
	end

	def parse_with(page,select)
		parsed_page = ''

		case select
			when 1
				parsed_page = page.css("iframe#hmovie")[0]["src"]
			when 2
				parsed_page = page.css("div#plot").text
			when 3
				parsed_page = page.css('td')
			when 4
				parsed_page = page.css('td[class="mnllinklist dotted"]')
			when 5

			else
				puts "thats not a choice"
		end
		parsed_page
	end

end
