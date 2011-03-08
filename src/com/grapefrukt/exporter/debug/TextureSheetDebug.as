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
	import com.grapefrukt.exporter.textures.Texture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class TextureSheetDebug {
		
		public static function render(sheet:TextureSheet, s:Sprite = null):Sprite {
			if(!s) s = new Sprite;
			var label:Label;
			
			for each (var texture:Texture in sheet.textures) {
				label = new Label(s, 0, s.getBounds(s).bottom, texture.name);
				if (texture.isMultiframe) label.text += "\n" + texture.frameCount + " frames";
				label.opaqueBackground = 0xffffff;
				
				var bmp:Bitmap = new Bitmap(texture.bitmap);
				s.addChild(bmp);
				bmp.y = s.getBounds(s).bottom + 10;
				
				var regpoint:Shape = new Shape;
				regpoint.graphics.lineStyle(1, 0x00ff00);
				regpoint.graphics.beginFill(0xff00ff);
				regpoint.graphics.drawCircle(bmp.x + texture.registrationPoint.x, bmp.y + texture.registrationPoint.y, 2);
				
				s.addChild(regpoint);
				
				
			}
			
			label = new Label(s, 0, 0, sheet.name);
			label.opaqueBackground = 0xaaaaaa;
			
			return s;
		}
		
	}

}