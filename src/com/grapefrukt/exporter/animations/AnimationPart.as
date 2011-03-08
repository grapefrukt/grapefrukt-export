package com.grapefrukt.exporter.animations {
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */

	public class AnimationPart {
		
		public var frames:Vector.<AnimationFrame>;
		public var name:String;
		
		public function AnimationPart(name:String) {
			this.name = name;
			frames = new Vector.<AnimationFrame>;
		}
	}

}