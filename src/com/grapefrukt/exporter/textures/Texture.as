package com.grapefrukt.exporter.textures {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class Texture {
		
		private var _name				:String;
		private var _bitmap				:BitmapData;
		private var _bounds				:Rectangle;
		private var _frame_count		:int;
		private var _z_index			:int = 0;
		private var _sheet				:TextureSheet;
		private var _is_mask			:Boolean = false;
		
		public function Texture(name:String, bitmap:BitmapData, bounds:Rectangle, zIndex:int, frameCount:int = 1, isMask:Boolean = false) {
			_name = name;
			_bitmap = bitmap;
			_bounds = bounds;
			_z_index = zIndex;
			_frame_count = frameCount;
			_is_mask = isMask;
		}
		
		public function get name():String { return _name; }
		public function get bitmap():BitmapData { return _bitmap; }
		
		public function get registrationPoint():Point { 
			return new Point( -_bounds.x, -_bounds.y);
		}
		
		public function get bounds():Rectangle { return _bounds; }
		
		public function get isMultiframe():Boolean {
			return _frame_count > 1;
		}
		
		public function get frameCount():int { return _frame_count; }
		
		public function get sheet():TextureSheet { return _sheet; }
		
		public function set sheet(value:TextureSheet):void {
			_sheet = value;
		}
		
		public function get filenameWithPath():String {
			return sheet.name + "/" + name + ".png";
		}
		
		public function get zIndex():int { return _z_index; }
		
		public function get isMask():Boolean { return _is_mask; }
		
	}

}