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

package com.grapefrukt.exporter.debug {
	import com.grapefrukt.exporter.animations.Animation;
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import com.grapefrukt.exporter.textures.MultiframeBitmapTexture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class AnimationExtractorDebug {

		public static function createSkeleton(animation:Animation, sheet:TextureSheet):Sprite {
			var skeleton:Sprite = new Sprite;
			for each (var partname:String in animation.partNames) {
				var texture:BitmapTexture = sheet.getTexture(partname) as BitmapTexture;
				var part:Bitmap;
				if(texture){
					part = new Bitmap(texture.bitmap, "auto", true);
				} else {
					part = new Bitmap(new BitmapData(44, 142, false, 0xff00ff));
					part.x = -23;
					part.y = -100;
				}
				
				var multiframe:MultiframeBitmapTexture = texture as MultiframeBitmapTexture;
				if (multiframe) {
					var mask:Shape = new Shape;
					mask.graphics.beginFill(0);
					mask.graphics.drawRect(multiframe.bounds.x, multiframe.bounds.y, multiframe.frameBounds.width, multiframe.frameBounds.height);
					bone.addChild(mask);
					part.mask = mask;
				}
				
				if(texture){
					part.x = -texture.registrationPoint.x;
					part.y = -texture.registrationPoint.y;
				}
				
				var bone:Sprite = new Sprite;
				bone.addChild(part);
				
				bone.name = partname;
				skeleton.addChild(bone);
			}
			
			var zarray:Array = [];
			for each (partname in animation.partNames) {
				var t:BitmapTexture = sheet.getTexture(partname) as BitmapTexture;
				zarray.push( { part : skeleton.getChildByName(partname), z : t ? t.zIndex : 0 } );
			}
			zarray.sortOn("z", Array.NUMERIC);
			
			for (var i:int = 0; i < zarray.length; i++) {
				skeleton.setChildIndex(zarray[i].part, i);
			}
			
			poseSkeleton(skeleton, animation, 0);
			return skeleton;
		}
		
		public static function poseSkeleton(skeleton:Sprite, animation:Animation, frame:uint = 0):void {
			for each (var partname:String in animation.partNames) {
				var bone:DisplayObject = skeleton.getChildByName(partname);
				var animationframe:AnimationFrame = animation.getFrame(partname, frame);
				bone.x        = animationframe.x;
				bone.y        = animationframe.y;
				bone.scaleX   = animationframe.scaleX;
				bone.scaleY   = animationframe.scaleY;
				bone.alpha    = animationframe.alpha;
				bone.rotation = animationframe.rotation;
			}
		}
		
	}

}