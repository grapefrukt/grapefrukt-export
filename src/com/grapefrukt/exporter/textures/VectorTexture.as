package com.grapefrukt.exporter.textures {
	import com.codeazur.as3swf.tags.TagDefineShape;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class VectorTexture {
		
		private var _name		:String;
		private var _shapeTag	:TagDefineShape;
		
		public function VectorTexture(name:String, shapeTag:TagDefineShape) {
			_name = name;
			_shapeTag = shapeTag;
		}
		
		public function get name():String { return _name; }
		public function get shapeTag():TagDefineShape { return _shapeTag; }
		
	}

}