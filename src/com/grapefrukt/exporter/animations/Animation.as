package com.grapefrukt.exporter.animations {
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class Animation {
		
		private var _name			:String;
		private var _frame_count	:int;
		private var _loop_at		:int;
		private var _parts			:Vector.<AnimationPart>;
		private var _parts_dict		:Dictionary;
		private var _mask			:String;
		
		public function Animation(name:String, frameCount:int, loopAt:int, parts:Array) {
			_loop_at = loopAt;
			if (_loop_at < -1) throw new Error ("animation cannot loop on negative frames");
			_frame_count = frameCount;
			_name = name;
			
			_parts = new Vector.<AnimationPart>();
			_parts_dict = new Dictionary;
			
			for each(var partName:String in parts) {
				var aw:AnimationPart = new AnimationPart(partName);
				_parts.push(aw);
				_parts_dict[partName] = aw;
			}
		}
		
		public function sortParts():void {
			_parts.sort(_sort);
		}
		
		public function setFrame(part:String, index:int, frame:AnimationFrame):void {
			_parts_dict[part].frames[index] = frame;
		}
		
		public function getFrame(part:String, index:uint):AnimationFrame {
			return _parts_dict[part].frames[index];
		}
		
		public function get partNames():Array { 
			var names:Array = [];
			for each (var wrapper:AnimationPart in _parts) names.push(wrapper.name);
			return names;
		}
		
		public function get frameCount():int { return _frame_count; }
		public function get name():String { return _name; }
		public function get loopAt():int { return _loop_at; }
		public function get partCount():int { return _parts.length; }
		
		public function get mask():String { return _mask; }
		
		public function set mask(value:String):void {
			_mask = value;
		}
		
		public function get parts():Vector.<AnimationPart> { return _parts; }
		
		private function _sort(x:AnimationPart, y:AnimationPart):Number {
			if (x.name < y.name) 	return -1;
			if (x.name > y.name) 	return 1;
			return  0;
		}
		
		
	}

}