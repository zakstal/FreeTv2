$:.unshift File.dirname(__FILE__)
require './lib/show'
require 'rspec'




describe "#space" do
	it "returns three spacse" do
		space(3).should == "\n\n\n"
	end
	it "returns five spaces" do
		space(5).should == "\n\n\n\n\n"
	end
end
