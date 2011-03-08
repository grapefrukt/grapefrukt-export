package com.grapefrukt.exporter.extractors {
	import com.grapefrukt.exporter.textures.FontSheet;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	
	public class FontExtractor {
		
		private static const DEFAULT_CHARS:String = "! \"#$%&'()*+,-./" + 
													"0123456789:;<=>?" + 
													"@ABCDEFGHIJKLMNO" + 
													"PQRSTUVWXY>[\\]^_" + 
													"ïabcdefghijklmno" + 
													"pqrstuvwxyzäÄöÖ " + 
													"åÅ";
		
		public static function extract(textFormat:TextFormat, characters:String = "", referenceChar:String = "M", cols:int = 16):FontSheet {
			var sprite:Sprite = new Sprite;
			sprite.name = textFormat.font.toLowerCase();
			
			if (characters == "") characters = DEFAULT_CHARS;
			var chars:Array = characters.split("");
			
			var count:int = 0;
			for each(var char:String in chars) {
				var text:TextField = new TextField;
				text.name = char;
				text.autoSize = TextFieldAutoSize.LEFT;
				text.defaultTextFormat = textFormat;
				text.text = char;
				sprite.addChild(text);
			}
			
			var fontSheet:FontSheet = TextureExtractor.extract(sprite, null, false, FontSheet) as FontSheet;
			fontSheet.merge();
			
			return fontSheet;
		}
		
	}

}