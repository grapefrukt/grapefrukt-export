package com.grapefrukt.exporter.textures {
	import com.codeazur.as3swf.tags.TagDefineShape;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class VectorTexture extends TextureBase {
		
		private var _name		:String;
		private var _shapeTag	:TagDefineShape;
		
		public function VectorTexture(name:String, zIndex:int, shapeTag:TagDefineShape) {
			super(name, zIndex, false);
			_shapeTag = shapeTag;
		}
		
		public function get shapeTag():TagDefineShape { return _shapeTag; }
		
	}

}