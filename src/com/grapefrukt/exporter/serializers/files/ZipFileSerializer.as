package com.grapefrukt.exporter.serializers.files {
	import deng.fzip.FZip;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class ZipFileSerializer implements IFileSerializer{
		
		private var _zip:FZip;
		
		public function ZipFileSerializer() {
			_zip = new FZip;
		}
		
		public function serialize(filename:String, file:ByteArray):void{
			_zip.addFile(filename, file, false);
		}
		
		public function output():void{
			var fr:FileReference = new FileReference;
			var zip:ByteArray = new ByteArray;
			_zip.serialize(zip);
			fr.save(zip, "data.zip");
		}
		
	}

}