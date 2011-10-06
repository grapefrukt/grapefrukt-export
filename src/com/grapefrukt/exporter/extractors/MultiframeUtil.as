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
	import com.grapefrukt.exporter.settings.Settings;
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import com.grapefrukt.exporter.textures.MultiframeBitmapTexture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	public class MultiframeUtil {
		
		/**
		 * Merges a series of separate BitmapTextures together into one big atlas
		 * @param	frames	The frames to merge
		 * @param	columns	The number of columns to use (Defaults to Settings.defaultMultiframeCols if set to -1)
		 * @return	A merged MultiFrameBitmapTexture with all the supplied frames
		 */
		public static function merge(frames:Vector.<BitmapTexture>, columns:int = -1):MultiframeBitmapTexture {
			var bounds		:Rectangle = frames[0].bounds.clone();
			var frameCount	:int = frames.length;
			var frame		:BitmapTexture;
			
			if (columns == -1) columns = Settings.defaultMultiframeCols;
			
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
			
			frameBounds.x = 0;
			frameBounds.y = 0;
			
			bounds.width = bitmap.width;
			bounds.height = bitmap.height;
			
			return new MultiframeBitmapTexture(frames[0].name, bitmap, bounds, frames[0].zIndex, frameCount, frameBounds.clone(), cols, frames[0].isMask);
		}
		
		/**
		 * Splits apart a MultiframeBitmapTexture into its frames again. Each frame will keep any padding that was added to it when merged. 
		 * @param	texture
		 * @param	sheet
		 * @return
		 */
		public static function split(texture:MultiframeBitmapTexture, sheet:TextureSheet = null):TextureSheet {
			if (!sheet) sheet = new TextureSheet(texture.name);
			
			for (var i:int = 0; i < texture.frameCount; i++) {
				var bmp:BitmapData = new BitmapData(texture.frameBounds.width, texture.frameBounds.height, true, 0x00000000);
				
				var mtx:Matrix = new Matrix;
				mtx.translate(-texture.frameBounds.width * (i % Settings.defaultMultiframeCols), -texture.frameBounds.height * Math.floor(i / Settings.defaultMultiframeCols))
				
				bmp.draw(texture.bitmap, mtx, null, null)
				
				var bounds:Rectangle = texture.frameBounds.clone();
				bounds.x = -texture.registrationPoint.x;
				bounds.y = -texture.registrationPoint.y;
				var newtex:BitmapTexture = new BitmapTexture(texture.name + "_" + i, bmp, bounds, 0);
				
				sheet.add(newtex);
			}
			
			return sheet;
		}
		
	}

}