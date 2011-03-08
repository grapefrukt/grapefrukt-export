package com.grapefrukt.exporter.debug {
	import com.grapefrukt.exporter.animations.Animation;
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.textures.Texture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class AnimationExtractorDebug {

		public static function createSkeleton(animation:Animation, sheet:TextureSheet):Sprite {
			var skeleton:Sprite = new Sprite;
			for each (var partname:String in animation.partNames) {
				var texture:Texture = sheet.getTexture(partname);
				var part:Bitmap;
				if(texture){
					part = new Bitmap(texture.bitmap, "auto", true);
				} else {
					part = new Bitmap(new BitmapData(44, 142, false, 0xff00ff));
					part.x = -23;
					part.y = -100;
				}
				
				if (texture && texture.frameCount > 1) {
					var mask:Shape = new Shape;
					mask.graphics.beginFill(0);
					mask.graphics.drawRect(texture.bounds.x, texture.bounds.y, texture.bounds.width, texture.bounds.height);
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
				var t:Texture = sheet.getTexture(partname);
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