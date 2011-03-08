package com.grapefrukt.exporter.serializers.images {
	import by.blooddy.crypto.image.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class PNGImageSerializer implements IImageSerializer{
		
		public function serialize(bitmapData:BitmapData):ByteArray{
			return PNGEncoder.encode(bitmapData);
		}
		
	}

}