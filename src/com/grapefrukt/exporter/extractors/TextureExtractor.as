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
	import com.grapefrukt.exporter.textures.Texture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	import flash.display.Sprite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class TextureExtractor {
		
		/**
		 * Experimental property to change the global scale of all exports. Use with caution.
		 */
		public static var scaleFactor	:Number = 1;
		
		/**
		 * This many pixels will be added to the measured size of the DisplayObject when rendered to a bitmap (these may not be empty due to rounding off errors and antialias)
		 */
		public static var edgeMarginRender	:int 	= 2;
		
		/**
		 * This many empty pixels will be added to each side of the texture when it's output (these will always be completely empty)
		 */
		public static var edgeMarginOutput	:int 	= 2;
		
		/**
		 * Textures smaller than this will be ignored. Set to a negative value to disable size check. 
		 */
		public static var tinyThreshold	:int  	= 5;
		
		/**
		 * Extracts the DisplayObjectContainers children into textures and animation sheets
		 * @param	target			The DisplayObjectContainer to extract from
		 * @param	ignore			An array of Strings that let's you ignore certain children
		 * @param	respectScale	If this is false all children will be extracted at 100%. Set to true to respect the scale of the children as they are in the parent.
		 * @param	returnClass		Ignore this. Used internally to return FontSheets when so needed. 
		 * @return	A TextureSheet containing the DisplayObjectContainers children
		 */
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
		
		public static function extractFromClasses(sheetName:String, ...rest):TextureSheet {
			var s:Sprite = new Sprite();
			s.name = sheetName;
			
			for each (var item:Class in rest) {
				var instance:Sprite = new item();
				instance.name = ChildFinder.getName(instance);
				s.addChild(instance);
			}

			return extract(s);
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
			
			bounds.x = 		Math.floor(bounds.x) 		- edgeMarginRender;
			bounds.y = 		Math.floor(bounds.y) 		- edgeMarginRender;
			bounds.height = Math.ceil(bounds.height) 	+ edgeMarginRender * 2;
			bounds.width = Math.ceil(bounds.width) 		+ edgeMarginRender * 2;
			
			if (tinyThreshold > 0 && bounds.width < tinyThreshold && bounds.height < tinyThreshold) {
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
			crop_rect.x 		-= edgeMarginOutput;
			crop_rect.y		 	-= edgeMarginOutput;
			crop_rect.width 	+= edgeMarginOutput * 2;
			crop_rect.height 	+= edgeMarginOutput * 2;
			
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