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
			return sheet.name + "/" + name;
		}
		
		public function get zIndex():int { return _z_index; }
		
		public function get isMask():Boolean { return _is_mask; }
		
	}

}