package com.grapefrukt.exporter.animations {
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
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