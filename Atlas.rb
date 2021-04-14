require_relative "AtlasPage.rb" 
require_relative "AtlasRegion.rb" 
require 'mini_magick'
def save_photo(photo,name,width,height,left,top,is_rota)
    img = MiniMagick::Image.open(photo)     
    w,h = img[:width], img[:height]         
    img.crop("#{height}x#{width}+#{left}+#{top}")
	if is_rota
		img.rotate "90"
	end
    img.write("split/"+name+".png") if !FileTest.exist?("split/"+name+".png")
end
formatNames = [
	'Alpha', 
    'Intensity',
    'LuminanceAlpha',
    'RGB565',
    'RGBA4444',
    'RGB888',
    'RGBA8888'
	]

textureFiltureNames = [
	'Nearest',
    'Linear',
    'MipMap', 
    'MipMapNearestNearest', 
    'MipMapLinearNearest',
    'MipMapNearestLinear', 
    'MipMapLinearLinear'
	]

textureWrap=[
	'mirroredRepeat',
	'clampToEdge',
	'repeat'
	]
	
class Atlas
	attr_accessor :pages,:regions
	def initialize(file_name)
		@pages=[]
		@regions=[]
		loadWithFile(file_name)
	end
	def loadWithFile(file_name)
		raise "file not exist!" if !FileTest.exist?(file_name)
		atlas_text=File.readlines(file_name)
		load(atlas_text)
	end
	def load(atlas_text)
		page=nil
		region=nil
		_page=nil
		_region={}
		for line in atlas_text
			value=line.strip.rstrip
			if value.size == 0
				_page={}
				page=nil
			end
			if page == nil
				if !(value.include?(":"))
					value=value.strip.rstrip
					_page["name"]=value
				else
					key,value=value.split(":")
					key=key.strip.rstrip
					value=value.strip.rstrip
					if value.include?(",")
						value=value.split(",")
						_page[key]=value.map {|s| s.strip.rstrip}
					else
						#value = value == "true"# ? false : true
						_page[key]=value
						#print [key,value],"\n"
					end
					if key == "repeat"
						page=AtlasPage.new(_page["name"])
						page.format=_page["format"]
						page.minFilter=_page["filter"][0]
						page.magFilter=_page["filter"][0]
						case _page["repeat"]
						when "x"
							page.uWrap=textureWrap.index('repeat')
							page.vWrap=textureWrap.index('clampToEdge')
						when "y"
							page.uWrap=textureWrap.index('clampToEdge')
							page.vWrap=textureWrap.index('repeat')
						when "xy"
							page.uWrap=textureWrap.index('repeat')
							page.vWrap=textureWrap.index('repeat')
						end
						@pages.push(page)
					end
				end
			else
				if !(value.include?(":"))
					value=value.strip.rstrip
					_region["name"]=value
				else
					key,value=value.split(":")
					key=key.strip.rstrip
					value=value.strip.rstrip
					if value.include?(",")
						value=value.split(",")
						_region[key]=value.map {|s| s.strip.rstrip}
					else
						#value = value == "false" ? false : true
						value = false if value == "false"
						value = true if value == "true"
						_region[key]=value
						#print [key,value],"\n"
					end
					if key == "index"
						region=AtlasRegion.new(_region["name"],page)
						region.rotate=_region["rotate"]
						region.x=_region["xy"][0]
						region.y=_region["xy"][1]
						region.width=_region["size"][0]
						region.height=_region["size"][1]
						if _region.keys.include?("split")
							region.splits=_region["split"]
							if _region.keys.include("pad")
								region.pads=_region["pad"]
							end
						end
						region.originalWidth=_region["orig"][0]
						region.originalHeight=_region["orig"][1]
						region.offsetX = _region["offset"][0]
                        region.offsetY = _region["offset"][1]
						region.index=_region["index"].to_i
						@regions.push(region)
						_region={}
						next
					end
				end
			end
		end
	end
end
#main start
a=Atlas.new("Idle01.txt")
for region in a.regions
	name=region.name
	tex_name=region.f_info.name
	width=region.width
	height=region.height
	rotate=region.rotate
	x=region.x
	y=region.y
	if height != "1" and height != "1"
		print [name,tex_name,width,height,x,y,rotate],"\n"
		if rotate# == "true"
			save_photo(tex_name,name,width,height,x,y,true)
			puts 1
		else
			save_photo(tex_name,name,height,width,x,y,false)
			puts 2
		end
	end
end