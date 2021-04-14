class AtlasPage
	attr_accessor :name,:format,:minFilter,:magFilter,:uWrap,:vWrap
	def initialize(ap_name)
		@name=ap_name
		@format=nil
		@minFilter=nil
		@magFilter=nil
		@uWrap=nil
		@vWrap=nil
	end
end