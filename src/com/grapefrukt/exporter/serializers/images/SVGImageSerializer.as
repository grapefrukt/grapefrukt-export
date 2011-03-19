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