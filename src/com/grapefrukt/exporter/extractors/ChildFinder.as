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

package com.grapefrukt.exporter.extractors {
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.Child;
	import com.grapefrukt.exporter.settings.Settings;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class ChildFinder {
		
		public static function findMultiframe(target:MovieClip):Vector.<Child> {
			var children:Object = { };
			
			for (var frame:int = 1; frame <= target.totalFrames; frame++) {
				target.gotoAndStop(frame);
				for (var childIndex:int = 0; childIndex < target.numChildren; childIndex++) {
					var name:String = target.getChildAt(childIndex).name;
					if (!children[name]) children[name] = frame;
				}
			}
			
			var childVector:Vector.<Child> = new Vector.<Child>;
			for (var label:String in children) {
				childVector.push(new Child(label, children[label]));
			}
			
			return childVector;
		}
		
		public static function findSingle(target:DisplayObjectContainer):Vector.<Child> {
			var children:Vector.<Child> = new Vector.<Child>;
			for (var i:int = 0; i < target.numChildren; i++) {
				children.push(new Child(target.getChildAt(i).name, 0));
			}
			
			return children;
		}
		
		public static function filter(parent:DisplayObjectContainer, children:Vector.<Child>, ignore:Array):void {
			for (var i:int = children.length - 1; i >= 0; i--) {
				if (ignore && ignore.indexOf(children[i].name) != -1) {
					children.splice(i, 1);
				} else if (Settings.ignoreUnnamed && children[i].name.indexOf("instance") == 0) {
					Logger.log("ChildFinder", "removing unnamed instance:", children[i].name + " at frame: " + children[i].frame + " in parent: " + parent, Logger.ERROR);
					children.splice(i, 1);
				}
			}
		}
		
		/**
		 * Loops over all children in supplied DisplayObjectContainer and names them according to their class
		 * @param	target
		 */
		public static function nameChildren(target:DisplayObjectContainer):void {
			for (var i:int = 0; i < target.numChildren; i++) {
				target.getChildAt(i).name = getName(target.getChildAt(i));
			}
		}
		
		/**
		 * Tries to figure out the name of the supplied object, if nothing can be found it is named after it's class name
		 * @param	instance	The instance to try and name
		 * @return	The found name
		 */
		public static function getName(instance:Object):String {
			var name:String;
			if (instance.hasOwnProperty("name")) name = instance.name;
			if (!name || name == "" || name.indexOf("instance") != -1) name = getClassname(instance);
			return name;
		}
		
		private static function getClassname(instance:*):String {
			var name:String = getQualifiedClassName(instance).toLowerCase();
			// strips package/namespace names
			name = name.replace( /.*(\.|::)/, '');
			// strips gfx from the end
			name = name.replace(/gfx/i, '');
			return name;
		}
		
	}

}