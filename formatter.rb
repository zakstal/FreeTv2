
module Formats

	def spacer(number_of_spaces)
		number_of_spaces.times {puts "\n"}
	end	

	def taber(number_of_tabs)
		number_of_tabs.times {puts "\t"}
	end

	def what_do_you_choose(number)
		self.each_with_index do |link, index|
			choose_form(link,index + number.to_i)
		end
	end

	def choose_form(choices, input_option)
		space = "                           "
		in_opt = "- type '#{input_option.to_s}'"
		choice = "\t#{choices.to_s}"
		choice.length
		new_space = space.length > choice.length ? space[(choice.length)..(space.length)] : "\t\t"
		your_choice = choice + new_space + in_opt
		puts your_choice 
	end

	def dupe(symb,many_times)
		result = ""
		many_times.times {result += symb}
		result
	end

	def title(title, indent)
		dupe("\t",indent) + dupe("_",3) + title + dupe("_", 8)
	end
	#header and footers must be in array form screen([header_inputs],[background_inputs],[footer_inputs])
	# for background_inputs, the first character is the beginning index# for the "type this" options, or
	# use "s" to add a non choice screen
	def screen(header_inputs, background_inputs, footer_inputs)
		#24 lines
	
 		header(header_inputs)
 		background(background_inputs)
 		footer(footer_inputs)
	end

	def header(*he)
		head = he.flatten
		if head == nil
			space(7)
		else

			count = head.count
			spacer(6 - count)
				head[0..2].each_with_index do |ti, index|
					puts title(ti.capitalize,index+1)
					spacer(1)
				end
			spacer(1)

		end
		#6 lines
	end

	def footer(*foo)
		foot = foo.flatten
		if foot == nil
			space(6)
		else

			count = foot.count
			spacer(4 - count)
			
				foot.each_with_index do |ti, index|
					puts "\t" + ti
				end
				
			spacer(2)
			option_choice

		end
		#6 lines
	end

	# see screen
	def background(*ins)
		inputs = ins.flatten

		space_amount = 9
		count = inputs.count
		back = inputs[1..space_amount]
		if inputs == nil
			space(space_amount)	
		elsif inputs[0] == "s"
			str = back*""
			ln = str.split("\n")
			count = ln.count
			ln[1..space_amount].each do |line|
				puts "\t" + line.strip 
			end
		else
			
			back.what_do_you_choose(inputs[0])
			
		end
		spacer(space_amount - (count -1))
	end
# end
# end
end