package com.grapefrukt.exporter.misc {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class FunctionQueue {
		
		private var _queue				:Vector.<Function>;
		private var _queue_timer		:Timer;
		
		public function FunctionQueue() {
			_queue = new Vector.<Function>;
			
			_queue_timer = new Timer(25, 0);
			_queue_timer.addEventListener(TimerEvent.TIMER, handleQueueTimer);
			_queue_timer.start();
		}
		
		public function add(f:Function):void {
			_queue.push(f);
		}
		
		private function handleQueueTimer(e:TimerEvent):void {
			if (_queue.length) _queue.shift()();
		}
		
	}

}