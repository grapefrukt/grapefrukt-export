package com.grapefrukt.exporter.collections {
	import com.grapefrukt.exporter.animations.Animation;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class AnimationCollection {
		
		private var _collection:Vector.<Animation>;
		
		public function AnimationCollection() {
			_collection = new Vector.<Animation>();
		}
		
		public function add(ts:Animation):void {
			_collection.push(ts);
		}
		
		public function sort():void {
			_collection = _collection.sort(_sort)
		}
		
		private function _sort(x:Animation, y:Animation):Number {
			if (x.name < y.name) 	return -1;
			if (x.name > y.name) 	return 1;
			return  0;
		}
		
		public function getByName(name:String):Animation {
			for each (var anim:Animation in _collection) {
				if (anim.name == name) return anim;
			}
			return null;
		}
		
		public function getAtIndex(index:int):Animation {
			return _collection[index];
		}
		
		public function get size():uint {
			return _collection.length;
		}
		
		public function get head():Animation {
			return _collection[0];
		}
		
		public function get tail():Animation {
			return _collection[_collection.length - 1];
		}
		
	}

}