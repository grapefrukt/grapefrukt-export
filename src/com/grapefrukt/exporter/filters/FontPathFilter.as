package com.grapefrukt.exporter.filters {
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class FontPathFilter implements IFilter {
		
		public function apply(data:ByteArray):ByteArray {
			data.position = 0;
			var str:String = data.readUTFBytes(data.length);
			str = str.replace(/<FontData>\s+<Texture>/g, '$&data/fonts/');
			
			data.clear();
			data.writeUTFBytes(str);
			return data;
		}
		
	}

}