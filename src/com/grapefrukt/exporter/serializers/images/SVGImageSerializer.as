package com.grapefrukt.exporter.serializers.images {
	import com.codeazur.as3swf.exporters.SVGShapeExporter;
	import com.grapefrukt.exporter.extractors.VectorExtractor;
	import com.grapefrukt.exporter.textures.TextureBase;
	import com.grapefrukt.exporter.textures.VectorTexture;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class SVGImageSerializer implements IImageSerializer {
		
		private var _exporter:SVGShapeExporter;
		
		public function SVGImageSerializer() {
			if(!VectorExtractor.swf) throw new Error("Could not access swf bytecode, please initialize VectorExtractor before instantiating this class.")
			_exporter = new SVGShapeExporter(VectorExtractor.swf)
		}
		
		public function serialize(texture:TextureBase):ByteArray {
			var vt:VectorTexture = texture as VectorTexture;
			if (!vt) throw new Error("SVGImageSerializer can only serialize VectorTextures");
			vt.shapeTag.export(_exporter);
			
			var ba:ByteArray = new ByteArray;
			ba.writeUTFBytes(_exporter.svg);
			
			return ba;
		}
		
		public function get extension():String{
			return ".svg";
		}
		
	}

}