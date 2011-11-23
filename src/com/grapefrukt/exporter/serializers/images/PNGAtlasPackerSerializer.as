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
	import com.grapefrukt.exporter.misc.MaxRectsBinPack;
	import com.grapefrukt.exporter.misc.TextureAtlasRect;
	import com.grapefrukt.exporter.serializers.files.IFileSerializer;
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import com.grapefrukt.exporter.textures.TextureBase;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class PNGAtlasPackerSerializer extends PNGImageSerializer {
		
		protected var _texture_rects	:Vector.<TextureAtlasRect>;		// stores packed rectangles, used for drawing everything to the atlas on output
		protected var _rect_dict		:Dictionary;					// used for looking up textures to their corresponding packed rect
		protected var _binpackers		:Vector.<MaxRectsBinPack>;		// the "bins" used, more are added as needed
		protected var _atlas_width		:uint;							// the size of the bins
		protected var _atlas_height		:uint;
		
		public function PNGAtlasPackerSerializer(atlasWidth:uint = 512, atlasHeight:uint = 512) {
			_texture_rects 	= new Vector.<TextureAtlasRect>;
			_rect_dict 		= new Dictionary;
			_binpackers 	= new Vector.<MaxRectsBinPack>;
			_atlas_width 	= atlasWidth;
			_atlas_height 	= atlasHeight;
			
			addBinPacker();
		}
		
		public function addBinPacker():void {
			_binpackers.push(new MaxRectsBinPack(_atlas_width, _atlas_height));
		}
		
		override public function serialize(texture:TextureBase):ByteArray {
			var bt:BitmapTexture = texture as BitmapTexture;
			var rect:Rectangle;
			
			if (bt.bounds.width > _atlas_width || bt.bounds.height > _atlas_height) {
				throw new Error("Texture " + bt.name + "(" + bt.bitmap.rect.width + "x" + bt.bitmap.rect.height + ") is too big to fit in atlas (" + _atlas_width + "x" + _atlas_height + ")");
				return;
			}
			
			var atlasIndex:int = -1;
			var binWasAdded:Boolean = false;
			
			while (!rect || rect.height == 0) {
				atlasIndex++;
				
				// texture did not fit in any previous bin
				if (atlasIndex >= _binpackers.length) {
					if (binWasAdded) {
						throw new Error("Can't fit " + texture.name + " in any atlas, giving up");
						return;
					}
					addBinPacker();
					binWasAdded = true;
				}
				
				rect = _binpackers[atlasIndex].insert(bt.bitmap.rect.width, bt.bitmap.rect.height, MaxRectsBinPack.METHOD_RECT_BEST_AREA_FIT);
			}
			
			var tar:TextureAtlasRect = new TextureAtlasRect(bt, rect, atlasIndex);
			_texture_rects.push(tar);
			_rect_dict[bt] = tar;
			
			return null;
		}
		
		public function output(fileSerializer:IFileSerializer):void {
			var atlases:Vector.<BitmapData> = new Vector.<BitmapData>;
			var i:int;
			
			for (i = 0; i < _binpackers.length; i++) {
				atlases.push(new BitmapData(_atlas_width, _atlas_height, true, 0x00000000));
			}
			
			for each(var tr:TextureAtlasRect in _texture_rects) {
				atlases[tr.atlasIndex].copyPixels(tr.texture.bitmap, tr.texture.bitmap.rect, tr.rect.topLeft);
			}
			
			for (i = 0; i < _binpackers.length; i++) {
				var bt:BitmapTexture = new BitmapTexture(getAtlasName(i), atlases[i], atlases[i].rect, 0);
				fileSerializer.serialize(bt.name + extension, super.serialize(bt));
			}
		}
		
		public function getRect(texture:BitmapTexture):TextureAtlasRect {
			return _rect_dict[texture];
		}
		
		override public function get extension():String {
			return ".png";
		}
		
		public function getAtlasName(index:int):String {
			return index.toString();
		}
		
		public function get atlasWidth():uint { return _atlas_width; }
		public function get atlasHeight():uint { return _atlas_height; }
		
	}

}