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

package com.grapefrukt.exporter.serializers.files {
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
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
			
		}
		
	}

}