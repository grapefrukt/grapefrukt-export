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

﻿package com.grapefrukt.exporter.extractors {
	
	import com.grapefrukt.exporter.animations.Animation;
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.collections.AnimationCollection;
	import com.grapefrukt.exporter.debug.Logger;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class AnimationExtractor {
		
		public static function extract(list:AnimationCollection, target:MovieClip, parts:Array):void {
			Logger.log("AnimationExtractor", "extracting", target.toString());
			var fragments:Vector.<AnimationFragment> = getFragments(target);
			
			for each(var fragment:AnimationFragment in fragments) {
				list.add(getAnimation(target, fragment, parts));
			}
		}
		
		private static function getFragments(mc:MovieClip):Vector.<AnimationFragment> {
			var labels:Array = mc.currentLabels;
			
			var fragments:Vector.<AnimationFragment> = new Vector.<AnimationFragment>;
			
			var name:String = ""
			var start:int = 0;
			var end:int = 0;
			var loop:int = 0;
			
			for (var i:uint = 0; i < labels.length; i++) {
				var label:FrameLabel = labels[i];
				if (name != "" && label.name.indexOf('loop') == 0) {
					loop = label.frame;
				} else {
					if (name != "") {
						end = label.frame - 1;
						fragments.push(new AnimationFragment(name, start, end, loop))
					}
					
					name = label.name;
					start = label.frame;
					loop = 0;
					end = 0;
					
				}
				
			}
			
			end = mc.totalFrames;
			fragments.push(new AnimationFragment(name, start, end, loop));
			
			return fragments;
		}
		
		private static function getAnimation(mc:MovieClip, fragment:AnimationFragment, parts:Array):Animation {
			var loopAt:int = -1;
			if ( fragment.loops ) loopAt = fragment.totalFrameCount - fragment.loopFrameCount - 1;
			var animation:Animation = new Animation(fragment.name, fragment.totalFrameCount, loopAt, parts);
			
			for each(var part:String in parts) {
				for (var frame:int = fragment.startFrame; frame <= fragment.endFrame; frame++){
					mc.gotoAndStop(frame);
					if (mc[part]) {
						animation.setFrame(part, frame - fragment.startFrame, new AnimationFrame(true, mc[part].x, mc[part].y, mc[part].scaleX, mc[part].scaleY, mc[part].rotation, mc[part].alpha, TextureExtractor.scaleFactor));
					} else {
						animation.setFrame(part, frame - fragment.startFrame, new AnimationFrame(false));
					}
				}
			}
			
			return animation;
		}
		
	}

}

class AnimationFragment {
	
	private var _name	:String = 	"";
	private var _start	:int = 		0;
	private var _end	:int = 		0;
	private var _loop	:int = 		0;
	
	public function AnimationFragment(name:String, start:int, end:int, loop:int) {
		_name = name;
		_start = start;
		_end = end;
		_loop = loop;
	}
	
	public function get name():String { return _name; }
	public function get loopFrame():int { return _loop; }
	public function get endFrame():int { return _end; }
	public function get startFrame():int { return _start; }
	
	public function get totalFrameCount():int { return _end - _start + 1; }
	public function get loopFrameCount():int { return _end - _loop; }
	public function get preLoopFrameCount():int { return _loop - _start; }
	
	public function get loops():Boolean { return _loop > 0; }
}
