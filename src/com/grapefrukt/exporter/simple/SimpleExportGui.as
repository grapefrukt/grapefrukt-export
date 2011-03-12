package com.grapefrukt.exporter.simple {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class SimpleExportGui extends Sprite {
		
		private var _text			:TextField;
		private var _progressbar	:Shape;
		
		public function SimpleExportGui() {
			// background
			graphics.beginFill(0x39a6d6);
			graphics.drawRect(0, 0, 100, 37);
			
			// progressbar background
			graphics.beginFill(0xffffff);
			graphics.drawRect(3, 3, 94, 6);
			
			// export button background
			graphics.beginFill(0xffffff);
			graphics.drawRect(3, 12, 94, 22);
			
			_progressbar = new Shape;
			_progressbar.graphics.beginFill(0xffcc55);
			_progressbar.graphics.drawRect(0, 0, 94, 6);
			_progressbar.x = 3;
			_progressbar.y = 3;
			addChild(_progressbar);
			
			var tf:TextFormat = new TextFormat("_sans", 12, 0, true);
			tf.align = TextFormatAlign.CENTER;
			
			_text = new TextField;
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.defaultTextFormat = tf;
			_text.width = 94;
			_text.x = 53;
			_text.y = 15;
			
			addChild(_text);
			
			mouseChildren = false;
		}
		
		public function setProgress(percent:Number):void {
			if (percent < 0) percent = 0;
			if (percent > 1) percent = 1;
			_progressbar.scaleX = percent;
		}
		
		public function setText(text:String):void {
			_text.text = text;
		}
		
	}

}