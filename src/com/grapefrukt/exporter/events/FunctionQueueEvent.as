package com.grapefrukt.exporter.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class FunctionQueueEvent extends Event {
		
		public static const CHANGE		:String = "functionqueueevent_change";
		public static const COMPLETE	:String = "functionqueueevent_complete";
		
		public function FunctionQueueEvent(type:String) { 
			super(type);
		} 
		
		public override function clone():Event { 
			return new FunctionQueueEvent(type);
		} 
	
	}
	
}