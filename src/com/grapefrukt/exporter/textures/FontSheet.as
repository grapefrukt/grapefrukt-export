/*
Copyright 2011 Martin Jonasson, grapefrukt games. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY grapefrukt games "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL grapefrukt games OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of grapefrukt games.
*/

package com.grapefrukt.exporter.textures {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class FontSheet extends TextureSheet {
		
		private var _line_height	:int = 0;
		private var _char_space		:int = 0;
		private var _word_space		:int = 0;
		
		private var _merged_texture		:BitmapTexture;
		private var _merged_texture_v	:Vector.<TextureBase>;
		
		public function FontSheet(name:String) {
			super(name);
		}
		
		public function merge(columns:int = 16):void{
			var bounds		:Rectangle = BitmapTexture(_textures[0]).bounds.clone();
			var texture		:BitmapTexture;
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
			
			_merged_texture = new BitmapTexture(super.name, bmp, bmp.rect, 0);
			_merged_texture.sheet = this;
			_merged_texture_v = new Vector.<TextureBase>;
			_merged_texture_v.push(_merged_texture);
			
		}
		
		override public function get textures():Vector.<TextureBase> { 
			return _merged_texture_v; 
		}
		
		public function get unmergedTextures():Vector.<TextureBase> {
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
		
		public function get filenameWithPath():String {
			return fontName + _merged_texture.extension;
		}
		
		public function get fontName():String { return _merged_texture.name; }
		override public function get name():String { return "fonts"; }
		
	}

}