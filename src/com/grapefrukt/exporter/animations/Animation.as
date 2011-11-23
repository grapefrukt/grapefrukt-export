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
	import com.grapefrukt.exporter.misc.Child;
	import com.grapefrukt.exporter.settings.Settings;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class Animation {
		
		private var _name			:String;
		private var _frame_count	:int;
		private var _loop_at		:int;
		private var _parts			:Vector.<AnimationPart>;
		private var _parts_dict		:Dictionary;
		private var _markers		:Vector.<AnimationMarker>;
		private var _mask			:String;
		private var _framerate		:Number;
		
		public function Animation(name:String, frameCount:int, loopAt:int, parts:Vector.<Child>) {
			_loop_at = loopAt;
			if (_loop_at < -1) throw new Error ("animation cannot loop on negative frames");
			_frame_count = frameCount;
			_name = name;
			
			_parts = new Vector.<AnimationPart>();
			_parts_dict = new Dictionary;
			
			_markers = new Vector.<AnimationMarker>;
			
			for each(var child:Child in parts) {
				var aw:AnimationPart = new AnimationPart(child.name);
				_parts.push(aw);
				_parts_dict[child.name] = aw;
			}
			
			_framerate = Settings.defaultFramerate;
		}
		
		public function sort():void {
			_parts.sort(_sort_animation_part);
			_markers.sort(_sort_marker);
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
		public function get parts():Vector.<AnimationPart> { return _parts; }
		public function get markers():Vector.<AnimationMarker> { return _markers; }
		
		public function get mask():String { return _mask; }
		public function set mask(value:String):void { _mask = value; }
		
		public function get framerate():Number { return _framerate; }
		public function set framerate(value:Number):void { _framerate = value; }
		
		private function _sort_animation_part(x:AnimationPart, y:AnimationPart):Number {
			if (x.name < y.name) 	return -1;
			if (x.name > y.name) 	return 1;
			return  0;
		}
		
		private function _sort_marker(x:AnimationMarker, y:AnimationMarker):Number {
			if (x.name < y.name) 	return -1;
			if (x.name > y.name) 	return 1;
			return  0;
		}
		
	}

}