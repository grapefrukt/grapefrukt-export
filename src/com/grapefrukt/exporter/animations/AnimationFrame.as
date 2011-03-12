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

package com.grapefrukt.exporter.animations {
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class AnimationFrame {
		
		
		private var _visible	:Boolean = true;
		private var _x			:Number;
		private var _y			:Number;
		private var _scaleX		:Number;
		private var _scaleY		:Number;
		private var _rotation	:Number;
		private var _alpha		:Number;
		private var _scale_factor:Number = 1;
		
		
		public function AnimationFrame(visible:Boolean, x:Number = 0, y:Number = 0, scaleX:Number = 0, scaleY:Number = 0, rotation:Number = 0, alpha:Number = 0, scaleFactor:Number = 1) {
			_visible = visible;
			_x = x;
			_y = y;
			_scaleY = scaleY;
			_scaleX = scaleX;
			_rotation = rotation;
			_alpha = alpha;
			_scale_factor = scaleFactor;
			
			if (_alpha == 0) _visible = false;
		}
		
		public function get alpha():Number { return _alpha; }
		public function get rotation():Number { return _rotation; }
		public function get rotationRadians():Number { return _rotation / 180 * Math.PI; }
		public function get scaleY():Number { return _scaleY; }
		public function get scaleX():Number { return _scaleX; }
		public function get y():Number { return _y * _scale_factor; }
		public function get x():Number { return _x * _scale_factor; }
		public function get visible():Boolean { return _visible; }
	
		
	}

}