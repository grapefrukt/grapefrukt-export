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
	
	import adobe.utils.CustomActions;
	import com.grapefrukt.exporter.animations.Animation;
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.animations.AnimationMarker;
	import com.grapefrukt.exporter.collections.AnimationCollection;
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.Child;
	import com.grapefrukt.exporter.settings.Settings;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class AnimationExtractor {
		
		/**
		 * Extracts animations from target into the supplied AnimationCollection
		 * @param	list	This is where extracted animations will be added
		 * @param	target	The MovieClip to extract from
		 * @param	ignore	A list of children to ignore (Array of strings)
		 */
		public static function extract(list:AnimationCollection, target:MovieClip, ignore:Array = null):void {
			Logger.log("AnimationExtractor", "extracting", target.toString());
			var fragments:Vector.<AnimationFragment> = getFragments(target);
			
			var parts:Vector.<Child> = ChildFinder.findMultiframe(target);
			ChildFinder.filter(target, parts, ignore);
			
			for each(var fragment:AnimationFragment in fragments) {
				list.add(getAnimation(target, fragment, parts));
			}
		}
		
		private static function getFragments(mc:MovieClip):Vector.<AnimationFragment> {
			var fragment:AnimationFragment;
			var labels:Array = mc.currentLabels;
			var fragments:Vector.<AnimationFragment> = new Vector.<AnimationFragment>;			
			
			var i:uint;
			for (i = 0; i < labels.length; i++) {
				// we only care about animation labels now, not event- or loop markers, if we come upon them, just skip em'
				if (labels[i].name.charAt(0) == "@" || labels[i].name.indexOf("loop") == 0) continue;
				
				// if there's a previous fragment, we mark it's end
				if (fragments.length) fragments[fragments.length - 1].endFrame = labels[i].frame - 1;
				
				// push the new fragment onto the list
				fragments.push(new AnimationFragment(labels[i].name, labels[i].frame));
			}
			
			// once we've done the entire list, we know the last fragment ends at the last frame of the animation
			if (fragments.length) fragments[fragments.length - 1].endFrame = mc.totalFrames;
			
			// and a second pass to find all loop and event markers
			for (i = 0; i < labels.length; i++) {
				if (labels[i].name.indexOf("loop") == 0) {
					fragment = getFragment(fragments, labels[i].frame);
					if (fragment) fragment.loopFrame = labels[i].frame;
				} else if (labels[i].name.charAt(0) == "@") {
					fragment = getFragment(fragments, labels[i].frame);
					if (fragment) fragment.markers.push(new AnimationMarker(labels[i].frame, labels[i].name.substr(1)));
				}
			}
			
			return fragments;
		}
		
		private static function getFragment(fragments:Vector.<AnimationFragment>, frame:int):AnimationFragment {
			for (var i:int = 0; i < fragments.length; i++) {
				if (fragments[i].startFrame > frame) return fragments[i - 1];
			}
			return fragments[fragments.length - 1];
		}
		
		
		private static function getAnimation(mc:MovieClip, fragment:AnimationFragment, parts:Vector.<Child>):Animation {
			var loopAt:int = -1;
			if ( fragment.loops ) loopAt = fragment.totalFrameCount - fragment.loopFrameCount - 1;
			var animation:Animation = new Animation(fragment.name, fragment.totalFrameCount, loopAt, parts);
			
			for each(var part:Child in parts) {
				for (var frame:int = fragment.startFrame; frame <= fragment.endFrame; frame++){
					mc.gotoAndStop(frame);
					if (mc[part.name]) {
						animation.setFrame(part.name, frame - fragment.startFrame, new AnimationFrame(true, mc[part.name].x, mc[part.name].y, mc[part.name].scaleX, mc[part.name].scaleY, mc[part.name].rotation, mc[part.name].alpha, Settings.scaleFactor));
					} else {
						animation.setFrame(part.name, frame - fragment.startFrame, new AnimationFrame(false));
					}
				}
			}
			
			for each (var marker:AnimationMarker in fragment.markers) {
				marker.frame -= fragment.startFrame;
				animation.markers.push(marker);
			}
			
			return animation;
		}
		
	}

}
import com.grapefrukt.exporter.animations.AnimationMarker;

class AnimationFragment {
	
	private var _name	:String = 	"";
	private var _start	:int = 		0;
	private var _end	:int = 		0;
	private var _loop	:int = 		0;
	private var _markers:Vector.<AnimationMarker>;
	
	public function AnimationFragment(name:String, start:int) {
		_name = name;
		_start = start;
		_markers = new Vector.<AnimationMarker>;
	}
	
	public function get name():String { return _name; }
	public function get startFrame():int { return _start; }
	
	public function get loopFrame():int { return _loop; }
	public function set loopFrame(value:int):void { _loop = value; }
	
	public function get endFrame():int { return _end; }
	public function set endFrame(value:int):void { _end = value; }
	
	public function get markers():Vector.<AnimationMarker> { return _markers; }
	
	public function get totalFrameCount():int { return _end - _start + 1; }
	public function get loopFrameCount():int { return _end - _loop; }
	public function get preLoopFrameCount():int { return _loop - _start; }
	
	public function get loops():Boolean { return _loop > 0; }
	
}
