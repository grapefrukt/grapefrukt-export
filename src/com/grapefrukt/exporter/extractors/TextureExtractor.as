package com.grapefrukt.exporter.extractors {
	
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.Child;
	import com.grapefrukt.exporter.textures.Texture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class TextureExtractor {
		
		public static var scaleFactor	:Number = 1;
		public static var render_margin	:int 	= 2;
		public static var output_margin	:int 	= 2;
		
		public static function extract(target:DisplayObjectContainer, ignore:Array = null, respectScale:Boolean = false, returnClass:Class = null):TextureSheet {
			Logger.log("TextureExtractor", "extracting", ChildFinder.getName(target));
			
			if (returnClass == null) returnClass = TextureSheet;
			
			var children:Vector.<Child>;
			if (target is MovieClip) {
				children = ChildFinder.findMultiframe(MovieClip(target));
			} else {
				children = ChildFinder.findSingle(target);
			}
			
			ChildFinder.filter(target, children, ignore);
			
			return childrenToSheet(target, children, respectScale, returnClass);
		}
		
		private static function childrenToSheet(target:DisplayObjectContainer, children:Vector.<Child>, respectScale:Boolean, returnClass:Class):TextureSheet {
			var sheet:TextureSheet = new returnClass(ChildFinder.getName(target));
			for each(var child:Child in children) {
				if (child.frame != 0) MovieClip(target).gotoAndStop(child.frame);
				
				var t:Texture = getAsTexture(child.name, target.getChildByName(child.name), respectScale);
				
				if(t) sheet.add(t);
			}
			return sheet;
		}
		
		private static function getAsTexture(name:String, target:DisplayObject, respectScale:Boolean):Texture {
			if (target as MovieClip && MovieClip(target).totalFrames > 1) {
				return getAsTextureMultiframe(name, MovieClip(target), respectScale);
			} else {
				return getAsTextureSingle(name, target, respectScale);
			}
		}
		
		private static function getAsTextureMultiframe(name:String, target:MovieClip, respectScale:Boolean):Texture {
			var frames:Vector.<Texture> = new Vector.<Texture>;
			for (var frameIndex:int = 1; frameIndex <= target.totalFrames; frameIndex++) {
				target.gotoAndStop(frameIndex);
				frames.push(getAsTextureSingle(name, target, respectScale));
			}
			
			return MultiframeUtil.merge(frames);
		}
		
		public static function getAsTextureSingle(name:String, target:DisplayObject, respectScale:Boolean):Texture {
			var bounds:Rectangle = target.getBounds(target);
			var compoundScale:Number = scaleFactor;
			
			if (respectScale) compoundScale *= target.scaleX;
			
			bounds.x 		*= compoundScale;
			bounds.y 		*= compoundScale;
			bounds.width 	*= compoundScale;
			bounds.height 	*= compoundScale;
			
			bounds.x = 		Math.floor(bounds.x) 		- render_margin;
			bounds.y = 		Math.floor(bounds.y) 		- render_margin;
			bounds.height = Math.ceil(bounds.height) 	+ render_margin * 2;
			bounds.width = Math.ceil(bounds.width) 		+ render_margin * 2;
			
			if (bounds.width < 5 && bounds.height < 5) {
				Logger.log("TextureExtractor", "skipping tiny texture in " + name, bounds.width + "x" + bounds.height, Logger.ERROR);
				return null;
			}
			
			// draws the object to the bitmap
			var bitmap:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.translate( -bounds.x / compoundScale, -bounds.y / compoundScale);
			matrix.scale(compoundScale, compoundScale);
			
			// alpha is stored in animations, so we normally don't want that in the spritesheet
			// to be safe the value is cached and then set back once the blitting is done
			var tmpAlpha:Number = target.alpha;
			target.alpha = 1;
			
			bitmap.draw(target, matrix, target.transform.colorTransform);
			
			// reset the alpha
			target.alpha = tmpAlpha;
			
			// find the non-transparent area of the texture, especially useful for textfields
			// they report a way bigger size than they actually take up
			var crop_rect:Rectangle = bitmap.getColorBoundsRect(0xffffffff, 0x00000000, false);
			
			if (crop_rect.width < 1 && crop_rect.height < 1) {
				Logger.log("TextureExtractor", "crop made tiny texture in " + name, "was: " + bounds + " became: " + crop_rect, Logger.ERROR);
				
				// returns the uncropped texture
				return new Texture(name, bitmap, bounds, zindex);
			}
			
			// add a margin to the edges to prevent wierd smoothing issues
			crop_rect.x 		-= output_margin;
			crop_rect.y		 	-= output_margin;
			crop_rect.width 	+= output_margin * 2;
			crop_rect.height 	+= output_margin * 2;
			
			// crop out transparency from the edges
			var crop_bitmap:BitmapData = new BitmapData(crop_rect.width, crop_rect.height, true, 0x00000000);
			crop_bitmap.draw(bitmap, new Matrix(1, 0, 0, 1, -crop_rect.x, -crop_rect.y));
			
			// calculate the new registration point position after the crop
			bounds.x += crop_rect.x;
			bounds.y += crop_rect.y;
			bounds.width = crop_rect.width;
			bounds.height = crop_rect.height;
			
			var zindex:uint = 0;
			if (target.parent) zindex = target.parent.getChildIndex(target);
			
			var isMask:Boolean = name.toLowerCase().indexOf('mask') == 0;
			return new Texture(name, crop_bitmap, bounds, zindex, 1, isMask);
		}
		
	}

}