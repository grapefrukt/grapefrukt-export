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

package com.grapefrukt.exporter.serializers.data {
	import com.grapefrukt.exporter.misc.TextureAtlasRect;
	import com.grapefrukt.exporter.serializers.images.PNGAtlasPackerSerializer;
	import com.grapefrukt.exporter.textures.BitmapTexture;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class XMLAtlasDataSerializer extends XMLDataSerializer {
		
		protected var _use_pixel_coords	:Boolean;
		protected var _atlaspacker		:PNGAtlasPackerSerializer;
		
		public function XMLAtlasDataSerializer(atlaspacker:PNGAtlasPackerSerializer, usePixelCoords:Boolean = false) {
			_use_pixel_coords = usePixelCoords;
			_atlaspacker = atlaspacker;
		}
		
		override protected function serializeTexture(texture:BitmapTexture):XML {
			var xml:XML = super.serializeTexture(texture);
			var rect:TextureAtlasRect = _atlaspacker.getRect(texture);
			
			xml.@atlas	= _atlaspacker.getAtlasName(rect.atlasIndex) + _atlaspacker.extension;
			xml.@top 	= scale(rect.rect.top, 		false);
			xml.@right 	= scale(rect.rect.right, 	true);
			xml.@bottom = scale(rect.rect.bottom, 	false);
			xml.@left 	= scale(rect.rect.left, 	true);
			
			return xml;
		}
		
		protected function scale(value:Number, xAxis:Boolean):Number {
			if (_use_pixel_coords) return Math.round(value);
			if (xAxis) return (value / _atlaspacker.atlasWidth);
			return (value / _atlaspacker.atlasHeight);
		}
		
	}

}