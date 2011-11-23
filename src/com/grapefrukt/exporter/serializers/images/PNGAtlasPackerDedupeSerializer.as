package com.grapefrukt.exporter.serializers.images {
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.TextureAtlasRect;
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import com.grapefrukt.exporter.textures.TextureBase;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class PNGAtlasPackerDedupeSerializer extends PNGAtlasPackerSerializer {
		
		private var _dictionary		:Dictionary;
		private var _dupePixelCount	:Number = 0;
		
		public function PNGAtlasPackerDedupeSerializer(atlasWidth:uint=512, atlasHeight:uint=512) {
			super(atlasWidth, atlasHeight);
			_dictionary = new Dictionary(true);
		}
		
		override public function serialize(texture:TextureBase):ByteArray {
			var newTexture:BitmapTexture = texture as BitmapTexture;
			if (!newTexture) throw new Error("PNGAtlasPackerDedupeSerializer only works on BitmapTextures");
			
			// check our dictionary if we've seen an image of this size before
			var oldTexture:BitmapTexture = _dictionary[newTexture.bitmap.rect.toString()];
			// if we have, let's do some more testing
			if (oldTexture) {
				// if BitmapData.compare() returns 0 the images are identical
				if (oldTexture.bitmap.compare(newTexture.bitmap) == 0) {
					// count how many pixels this saved us
					_dupePixelCount += oldTexture.bitmap.width * oldTexture.bitmap.height;
					Logger.log("PNGAtlasPackerDedupeSerializer", "dupe found", newTexture.name + " is identical to " + oldTexture.name + ", duped pixels", Logger.NOTICE);
					
					// fetch the TextureAtlasRect for the old texture
					var oldTar:TextureAtlasRect = _rect_dict[oldTexture];
					
					// we create a new TextureAtlasRect for the new texture, but use the same rect as the old one
					// we also don't add it to the _texture_rects, since that would make it be drawn twice
					var newTar:TextureAtlasRect = new TextureAtlasRect(newTexture, oldTar.rect, oldTar.atlasIndex);
					_rect_dict[newTexture] = newTar;
					
					return null;
				}
			}
			
			// if we haven't seen it before, add it to the dictionary and let the regular atlas packer deal with it
			_dictionary[newTexture.bitmap.rect.toString()] = newTexture;
			return super.serialize(texture);
		}
		
	}

}