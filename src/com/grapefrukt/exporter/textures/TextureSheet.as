package com.grapefrukt.exporter.textures {
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class TextureSheet {
		
		protected var _name:String;
		protected var _textures:Vector.<Texture>;
		
		public function TextureSheet(name:String) {
			_name = name;
			_textures = new Vector.<Texture>;
		}
		
		public function add(texture:Texture):void {
			texture.sheet = this;
			_textures.push(texture);
		}
		
		public function addExternal(texture:Texture):void {
			_textures.push(texture);
		}
		
		public function getTexture(name:String):Texture {
			for each(var t:Texture in _textures) {
				if (t.name == name) return t;
			}
			return null;
		}
		
		public function removeTexture(name:String):Texture {
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
		
		public function get textures():Vector.<Texture> { return _textures; }
		public function get name():String { return _name; }
		
		protected function _sort_textures(one:Texture, two:Texture):Number {
			if (one.zIndex > two.zIndex) return -1;
			if (one.zIndex < two.zIndex) return 1;
			return 0;
		}
		
	}

}