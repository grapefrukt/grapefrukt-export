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

package com.grapefrukt.exporter.misc {
	import com.grapefrukt.exporter.events.FunctionQueueEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * This class keeps a Vector of Functions and calls these on a short timer. This is useful for two things, firstly it's needed to avoid script timeouts on long exports.
	 * Secondly it makes aborting or pausing the export on errors very easy. 
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	
	[Event(name = "functionqueueevent_change", type = "com.grapefrukt.exporter.events.FunctionQueueEvent")]
	[Event(name = "functionqueueevent_complete", type = "com.grapefrukt.exporter.events.FunctionQueueEvent")]
	
	public class FunctionQueue extends EventDispatcher {
		
		private var _queue				:Vector.<Function>;
		private var _queue_timer		:Timer;
		private var _peak_length		:uint = 0;
		
		public function FunctionQueue() {
			_queue = new Vector.<Function>;
			
			_queue_timer = new Timer(25, 0);
			_queue_timer.addEventListener(TimerEvent.TIMER, handleQueueTimer);
		}
		
		/**
		 * Stops the timer that makes the queue tick. 
		 */
		public function stop():void {
			_queue_timer.stop();
		}
		
		/**
		 * Starts the timer that will make the queue tick
		 */
		public function start():void {
			_queue_timer.start();
		}
		
		/**
		 * Adds a function to the end of the queue. If the timer that calls things in the queue isn't already running this will start it.
		 * @param	f The function to add
		 */
		public function add(f:Function):void {
			_queue.push(f);
			if (length > _peak_length) _peak_length = length;
			
			_queue_timer.start();
			dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.CHANGE));
		}
		
		private function handleQueueTimer(e:TimerEvent):void {
			if (_queue.length) {
				_queue.shift()();
				dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.CHANGE));
			} else {
				_queue_timer.stop();
				dispatchEvent(new FunctionQueueEvent(FunctionQueueEvent.COMPLETE));
			}
		}
		
		/**
		 * The current length of the queue
		 */
		public function get length():uint { return _queue.length; }
		
		/**
		 * The maximum length the queue has had
		 */
		public function get peakLength():uint { return _peak_length; }
		
	}

}