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
	import com.grapefrukt.exporter.settings.Settings;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class MultiframeBitmapTexture extends BitmapTexture{

		private var _frame_count	:int;
		private var _framerate		:Number;
		private var _frame_bounds	:Rectangle;
		private var _columns		:int;
		
		public function MultiframeBitmapTexture(name:String, bitmap:BitmapData, bounds:Rectangle, zIndex:int, frameCount:int, frameBounds:Rectangle, cols:int, isMask:Boolean = false) {
			super(name, bitmap, bounds, zIndex, isMask);
			_columns = cols;
			_frame_count = frameCount;
			_frame_bounds = frameBounds;
			framerate = Settings.defaultFramerate;
		}
		
		public function get frameCount():int { return _frame_count; }
		public function get frameBounds():Rectangle { return _frame_bounds; }
		public function get columns():int { return _columns; }
		
		public function get framerate():Number { return _framerate; }
		public function set framerate(value:Number):void {	_framerate = value; }
		
	}

}