package com.grapefrukt.exporter.textures {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class FontSheet extends TextureSheet {
		
		private var _line_height	:int = 0;
		private var _char_space		:int = 0;
		private var _word_space		:int = 0;
		
		private var _merged_texture		:Texture;
		private var _merged_texture_v	:Vector.<Texture>;
		
		public function FontSheet(name:String) {
			super(name);
		}
		
		public function merge(columns:int = 16):void{
			var bounds		:Rectangle = _textures[0].bounds.clone();
			var texture		:Texture;
			// expand the bounds to cover all textures
			for each(texture in _textures) {
				if (texture.bounds.left 	< bounds.left) 		bounds.left = 	texture.bounds.left;
				if (texture.bounds.right 	> bounds.right) 	bounds.right = 	texture.bounds.right;
				if (texture.bounds.top 		< bounds.top) 		bounds.top = 	texture.bounds.top;
				if (texture.bounds.bottom 	> bounds.bottom) 	bounds.bottom = texture.bounds.bottom;
			}
			
			var merge_w:int = (_textures.length % columns) * bounds.width;
			if (_textures.length > columns) merge_w = columns * bounds.width;
			var merge_h:int = Math.ceil(_textures.length / columns) * bounds.height;
			
			var bmp:BitmapData = new BitmapData(merge_w, merge_h, true, 0x00000000);
			
			var i:int = 0;
			for each(texture in _textures) {
				
				// many fonts have strange amounts of space above, the bounds check catches this, but we need to compensate 
				// for that offset when blitting into the merged texture, hence the subtraction of bounds.left/bounds.top
				texture.bounds.offset((i % columns) * bounds.width - bounds.left, Math.floor(i / columns) * bounds.height  - bounds.top);
				
				var mtx:Matrix = new Matrix();
				mtx.translate(texture.bounds.left, texture.bounds.top);
				bmp.draw(texture.bitmap, mtx);
				
				texture.bounds.top = Math.floor(i / columns) * bounds.height;
				i++;
			}
			
			_merged_texture = new Texture(super.name, bmp, bmp.rect, 0);
			_merged_texture.sheet = this;
			_merged_texture_v = new Vector.<Texture>;
			_merged_texture_v.push(_merged_texture);
			
		}
		
		override public function get textures():Vector.<Texture> { 
			return _merged_texture_v; 
		}
		
		public function get unmergedTextures():Vector.<Texture> {
			return super.textures;
		}
		
		public function get lineHeight():int { return _line_height; }
		public function set lineHeight(value:int):void {
			_line_height = value;
		}
		
		public function get charSpace():int { return _char_space; }
		public function set charSpace(value:int):void {
			_char_space = value;
		}
		
		public function get wordSpace():int { return _word_space; }
		public function set wordSpace(value:int):void {
			_word_space = value;
		}
		
		public function get fontName():String { return _merged_texture.name; }
		override public function get name():String { return "fonts"; }
		
	}

}