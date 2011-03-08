package com.grapefrukt.exporter.serializers.files {
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class FileOutSerializer implements IFileSerializer{
	
		public static const OVERWRITE_ALL				:String = "all";
		public static const OVERWRITE_NONE				:String = "none";
		public static const OVERWRITE_DIFFERENT_SIZE	:String = "different_size";
		
		private var _base_path			:File;
		private var _overwrite_style	:String;
			
		public function FileOutSerializer(path:String, overwriteStyle:String = OVERWRITE_DIFFERENT_SIZE) {
			_base_path = new File(path);
			
			if (!_base_path.exists) throw new Error("output folder doesn't exist!");
			if (!_base_path.isDirectory) throw new Error("output folder isn't a folder!");
			
			_overwrite_style = overwriteStyle;
		}
		
		public function serialize(filename:String, data:ByteArray):void {
			var outFile:File = _base_path.resolvePath(filename)
			
			if (_overwrite_style == OVERWRITE_NONE && outFile.exists) return;
			if (_overwrite_style == OVERWRITE_DIFFERENT_SIZE && outFile.exists && outFile.size == data.length) {
				trace("skipping", outFile.nativePath, "same size");
				return;
			}
			
			trace("writing", outFile.nativePath);
			var fs:FileStream = new FileStream();
			fs.open(outFile, FileMode.WRITE);
			fs.writeBytes(data);
			fs.close();
		}
		
		public function output():void{
			NativeApplication.nativeApplication.exit();
		}
		
	}

}