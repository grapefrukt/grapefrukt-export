package com.grapefrukt.exporter.extractors {
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.Child;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class ChildFinder {
		
		public static function findMultiframe(target:MovieClip):Vector.<Child> {
			var children:Object = { };
			
			for (var frame:int = 1; frame < target.totalFrames; frame++) {
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
				} else if (children[i].name.indexOf("instance") != -1) {
					Logger.log("ChildFinder", "removing unnamed instance:", children[i].name + " at frame: " + children[i].frame + " in parent: " + parent, Logger.ERROR);
					children.splice(i, 1);
				}
			}
		}
		
		public static function nameChildren(target:DisplayObjectContainer):void {
			for (var i:int = 0; i < target.numChildren; i++) {
				target.getChildAt(i).name = getName(target.getChildAt(i));
			}
		}
		
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