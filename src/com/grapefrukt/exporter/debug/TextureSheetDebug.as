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