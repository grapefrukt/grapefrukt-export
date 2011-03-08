package com.grapefrukt.exporter.debug {
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class Logger {
		
		public static const DEBUG	:int = 0;
		public static const NOTICE	:int = 1;
		public static const ERROR	:int = 2;
		public static const FATAL	:int = 3;
		public static const LEVELS	:Array = ["DEBUG", "NOTICE", "ERROR", "FATAL"];
		
		private static var _dispatcher:EventDispatcher;
		
		public function Logger() {
			
		}
		
		public static function log(source:String, message:String, description:String = "", severity:int = DEBUG):void {
			trace(source, message, description)
			dispatcher.dispatchEvent(new LogEvent(severity, source, message, description));
		}
		
		static public function get dispatcher():EventDispatcher { 
			if (!(_dispatcher)) _dispatcher = new EventDispatcher;
			return _dispatcher; 
		}
		
		
		
	}

}