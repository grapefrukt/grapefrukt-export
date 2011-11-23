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
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TextureSheet {
		
		protected var _name:String;
		protected var _textures:Vector.<TextureBase>;
		
		public function TextureSheet(name:String) {
			_name = name;
			_textures = new Vector.<TextureBase>;
		}
		
		/**
		 * Adds a texture to this sheet and marks it as belonging to this sheet
		 * @param	texture
		 */
		public function add(texture:TextureBase):void {
			texture.sheet = this;
			_textures.push(texture);
		}
		
		/**
		 * Adds a texture to this sheet without marking it as belonging to this sheet (Useful for textures that are in multiple sheets)
		 * @param	texture
		 */
		public function addExternal(texture:TextureBase):void {
			_textures.push(texture);
		}
		
		public function getTexture(name:String):TextureBase {
			for each(var t:TextureBase in _textures) {
				if (t.name == name) return t;
			}
			return null;
		}
		
		/**
		 * Removes a texture from this sheet. Note that the texture will still be associated with with the sheet unless you explicitly set TextureBase.sheet to null.
		 * @param	name The texture to remove
		 * @return	The removed texture (null if no texture was removed)
		 * @see		com.grapefrukt.exporter.textures.TextureBase#sheet
		 */
		public function removeTexture(name:String):TextureBase {
			for (var i:int = 0; i < _textures.length; i++) {
				if (_textures[i].name == name) {
					return _textures.splice(i, 1)[0];
				}
			}
			return null;
		}
		
		public function sort():void{
			_textures = _textures.sort(_sort_textures);
		}
		
		public function get textures():Vector.<TextureBase> { return _textures; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		
		protected function _sort_textures(one:TextureBase, two:TextureBase):Number {
			// first sort on z-index
			if (one.zIndex > two.zIndex) return -1;
			if (one.zIndex < two.zIndex) return 1;
			
			// if z-index isn't available or identical, we sort on names
			if (one.name < two.name) return -1;
			if (one.name > two.name) return 1;
			
			return 0;
		}
		
	}

}