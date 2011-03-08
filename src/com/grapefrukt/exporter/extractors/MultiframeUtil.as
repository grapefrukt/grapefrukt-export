package com.grapefrukt.exporter.extractors {
	import com.grapefrukt.exporter.textures.Texture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class MultiframeUtil {
		
		public static const COLS_DEFAULT:uint = 4
		
		public static function merge(frames:Vector.<Texture>, columns:int = COLS_DEFAULT, returnClass:Class = null):Texture {
			var bounds		:Rectangle = frames[0].bounds.clone();
			var frameCount	:int = frames.length;
			var frame		:Texture;
			
			if (returnClass == null) returnClass = Texture;
			
			// expand the bounds to cover all frames
			for each(frame in frames) {
				if (frame.bounds.left 	< bounds.left) 		bounds.left = 	frame.bounds.left;
				if (frame.bounds.right 	> bounds.right) 	bounds.right = 	frame.bounds.right;
				if (frame.bounds.top 	< bounds.top) 		bounds.top = 	frame.bounds.top;
				if (frame.bounds.bottom > bounds.bottom) 	bounds.bottom = frame.bounds.bottom;
			}
			
			var cols:int = Math.min(frameCount, columns);
			var rows:int = Math.ceil(frameCount / columns);
			
			var bitmap:BitmapData = new BitmapData(bounds.width * cols, bounds.height * rows, true, 0x00000000);
			
			var matrix:Matrix;
			var frameBounds:Rectangle;
			for (var i:int = 0; i < frameCount; i++) {
				frame = frames[i];
				frameBounds = new Rectangle(bounds.width * (i % columns), bounds.height * Math.floor(i / columns), bounds.width, bounds.height);
				matrix = new Matrix;
				matrix.translate(frameBounds.x + frame.bounds.left - bounds.left, frameBounds.y + frame.bounds.top - bounds.top);
				bitmap.draw(frame.bitmap, matrix, null, null, frameBounds);
			}
			
			return new returnClass(frames[0].name, bitmap, bounds, frames[0].zIndex, frameCount);
		}
		
		public static function split(texture:Texture, sheet:TextureSheet = null):TextureSheet {
			if (!sheet) sheet = new TextureSheet(texture.name);
			
			for (var i:int = 0; i < texture.frameCount; i++) {
				var bmp:BitmapData = new BitmapData(texture.bounds.width, texture.bounds.height, true, 0x00000000);
				
				//var bounds:Rectangle = new Rectangle(texture.bounds.width * (i % COLS_DEFAULT), texture.bounds.height * Math.floor(i / COLS_DEFAULT), texture.bounds.width, texture.bounds.height);
				var mtx:Matrix = new Matrix;
				
				mtx.translate(-texture.bounds.width * (i % COLS_DEFAULT), -texture.bounds.height * Math.floor(i / COLS_DEFAULT))
				
				bmp.draw(texture.bitmap, mtx, null, null)
				
				var newtex:Texture = new Texture(texture.name + "_" + i, bmp, texture.bounds, 0);
				
				sheet.add(newtex);
			}
			
			return sheet;
		}
		
	}

}