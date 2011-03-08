package com.grapefrukt.exporter.collections {
	import com.grapefrukt.exporter.textures.TextureSheet;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class TextureSheetCollection{
		
		private var _collection:Vector.<TextureSheet>;
		
		public function TextureSheetCollection() {
			_collection = new Vector.<TextureSheet>();
		}
		
		public function add(ts:TextureSheet):void {
			_collection.push(ts);
		}
		
		public function sort():void {
			_collection = _collection.sort(_sort)
		}
		
		private function _sort(x:TextureSheet, y:TextureSheet):Number {
			if (x.name < y.name) 	return -1;
			if (x.name > y.name) 	return  1;
			return  0;
		}
		
		public function remove(sheet:TextureSheet):void {
			_collection.splice(_collection.indexOf(sheet), 1);
		}
		
		public function getByName(name:String):TextureSheet {
			for each (var anim:TextureSheet in _collection) {
				if (anim.name == name) return anim;
			}
			return null;
		}
		
		public function getAtIndex(index:int):TextureSheet {
			return _collection[index];
		}
		
		public function get size():uint {
			return _collection.length;
		}
		
		public function get head():TextureSheet {
			return _collection[0];
		}
		
		public function get tail():TextureSheet {
			return _collection[_collection.length - 1];
		}
		
		public function get sheets():Vector.<TextureSheet> { return _collection; }
		
	}

}