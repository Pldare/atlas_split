class AtlasRegion
	attr_accessor :name
    attr_accessor :x
    attr_accessor :y
    attr_accessor :width
    attr_accessor :height
    attr_accessor :offsetX
    attr_accessor :offsetY
    attr_accessor :originalWidth
    attr_accessor :originalHeight
    attr_accessor :index
    attr_accessor :rotate
    attr_accessor :flip
    attr_accessor :splits
    attr_accessor :pads
	attr_accessor :f_info
	def initialize(ar_name,f_info)
		@name = ar_name
		@x = 0
		@y = 0
		@width = 0
		@height = 0
		@offsetX = 0.0
		@offsetY = 0.0
		@originalWidth = 0
		@originalHeight = 0
		@index = 0
		@rotate = false
		@flip = false
		@splits = []
		@pads = []
		@f_info=f_info
	end
end