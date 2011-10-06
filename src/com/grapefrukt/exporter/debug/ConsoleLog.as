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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class ConsoleLog extends Sprite {
		
		private var _text			:TextField;
		private var _log_color		:Vector.<String>;
		
		private var _width			:int;
		private var _height			:int;
		private var _minimum_level	:int;
		private var _margin			:int = 5;
		
		/**
		 * Creates a text window that displays all logging statements from the exporter
		 * @param	width			Vertical size of the window
		 * @param	height			Horizontal size of the window
		 * @param	minimumLevel	The minimum error level to log, Logger.DEBUG is the lowest, Logger.FATAL is the highest
		 * @param	backgroundColor	The background color for the window
		 * @param	textColor		The text color for the window
		 */
		public function ConsoleLog(width:int = 800, height:int = 600, minimumLevel:int = Logger.DEBUG, backgroundColor:int = 0xffffff) {
			_height = height;
			_width = width;
			_minimum_level = minimumLevel;
			
			_log_color = Vector.<String>(["#000000", "#000000", "#8F43A3", "#C40000"]);
			
			_text 					= new TextField();
			_text.selectable 		= true;
			_text.defaultTextFormat = new TextFormat("Consolas", 11, 0x000000);
			_text.mouseWheelEnabled = true;
			_text.opaqueBackground  = backgroundColor;
			_text.height 			= _height;
			_text.width 			= _width;
			_text.wordWrap			= false;
			_text.multiline			= true;
			addChild(_text);
			
			_text.htmlText = "ConsoleLog - grapefrukt asset exporter - " + new Date();
			
			Logger.dispatcher.addEventListener(	LogEvent.LOG, handleLog);
		}
		
		private function handleLog(e:LogEvent):void {
			if (e.severity < _minimum_level) return;
			_text.htmlText += '<font color="' + _log_color[e.severity] + '">' + timestamp() + e.source + " : " + e.message + " - " + e.description + "</font>";
			_text.scrollV = _text.maxScrollV;
		}
		
		private function timestamp():String {
			var d:Date = new Date;
			return "[" + zeroPad(d.getHours().toString()) + ":" + zeroPad(d.getMinutes().toString()) + ":" + zeroPad(d.getSeconds().toString()) + "] "
		}
		
		private static function zeroPad(string:String, len:int = 2):String {
			while (string.length < len) string = '0' + string;
			return string;
		}	
		
	}

}