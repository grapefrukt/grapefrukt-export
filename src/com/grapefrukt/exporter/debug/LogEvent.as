package com.grapefrukt.exporter.debug {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class LogEvent extends Event {
		
		public static const LOG:String = "logevent_log";
		
		private var _severity		:int = 0;
		private var _source			:String = "";
		private var _message		:String = "";
		private var _description	:String = "";
		
		public function LogEvent(severity:int, source:String, error:String, description:String = "") { 
			super(LOG, bubbles, cancelable);
			_severity = severity;
			_source = source;
			_message = error;
			_description = description;
		} 
		
		public override function clone():Event { 
			return new LogEvent(_severity, _message, _description);
		} 
		
		public override function toString():String { 
			return formatToString("LogEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get severity():int { return _severity; }
		public function get message():String { return _message; }
		public function get description():String { return _description; }
		public function get source():String { return _source; }
		
	}
	
}