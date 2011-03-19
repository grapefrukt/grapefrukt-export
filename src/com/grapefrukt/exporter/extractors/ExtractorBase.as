package com.grapefrukt.exporter.extractors {
	import com.grapefrukt.exporter.misc.Child;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class ExtractorBase {
		
		protected static function getChildren(sheet:DisplayObjectContainer, ignore:Array):Vector.<Child> {
			var children:Vector.<Child>;
			var mc:MovieClip = sheet as MovieClip;
			if (mc && mc.totalFrames > 1) {
				children = ChildFinder.findMultiframe(mc);
			} else {
				children = ChildFinder.findSingle(sheet);
			}
			
			ChildFinder.filter(sheet, children, ignore)
			
			return children;
		}
		
		protected static function classesToSheetSprite(sheetName:String, classes:Array):Sprite {
			var s:Sprite = new Sprite();
			s.name = sheetName;
			
			for each (var item:Class in classes) {
				var instance:Sprite = new item();
				instance.name = ChildFinder.getName(instance);
				s.addChild(instance);
			}

			return s;
		}
		
	}

}