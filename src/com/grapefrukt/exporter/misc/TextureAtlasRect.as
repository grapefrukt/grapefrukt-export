package com.grapefrukt.exporter.misc {
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TextureAtlasRect {
		
		private var _texture		:BitmapTexture;
		private var _rect			:Rectangle;
		private var _atlas_index	:uint = 0;
		
		public function TextureAtlasRect(texture:BitmapTexture, rect:Rectangle, atlasIndex:uint) {
			_rect = rect;
			_texture = texture;
			_atlas_index = atlasIndex;
		}
		
		public function get texture():BitmapTexture { return _texture; }
		public function get rect():Rectangle { return _rect; }
		public function get atlasIndex():uint { return _atlas_index; }
		
	}

}