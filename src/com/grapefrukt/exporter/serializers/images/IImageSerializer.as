package com.grapefrukt.exporter.serializers.images {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public interface IImageSerializer {
		function serialize(bitmapData:BitmapData):ByteArray;
	}
	
}