package com.grapefrukt.exporter.textures {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TextureBase {

		private var _name			:String;
		private var _z_index		:int = 0;
		private var _is_mask		:Boolean = false;
		
		public function TextureBase(name:String, zIndex:int, isMask:Boolean) {
			_name = name;
			_z_index = zIndex;
			_is_mask = isMask;
		}
		
		public function get name():String { return _name; }
		public function get zIndex():int { return _z_index; }
		public function get isMask():Boolean { return _is_mask; }
	}

}