package com.grapefrukt.exporter.textures {
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TextureBase {

		private var _name			:String;
		private var _sheet			:TextureSheet;
		private var _z_index		:int = 0;
		private var _is_mask		:Boolean = false;
		private var _extension		:String;
		
		public function TextureBase(name:String, zIndex:int, isMask:Boolean) {
			_name = name;
			_z_index = zIndex;
			_is_mask = isMask;
		}
		
		public function get name():String { return _name; }
		public function get zIndex():int { return _z_index; }
		public function get isMask():Boolean { return _is_mask; }
		
		public function get filenameWithPath():String {
			return sheet.name + "/" + name + extension;
		}
		
		public function get sheet():TextureSheet { return _sheet; }
		public function set sheet(value:TextureSheet):void {
			_sheet = value;
		}
		
		public function get extension():String { return _extension; }
		public function set extension(value:String):void {
			_extension = value;
		}
	}

}