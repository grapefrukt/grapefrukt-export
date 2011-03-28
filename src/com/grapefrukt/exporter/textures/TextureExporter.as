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

package com.grapefrukt.exporter.textures {
	import com.grapefrukt.exporter.collections.TextureSheetCollection;
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.FunctionQueue;
	import com.grapefrukt.exporter.serializers.files.IFileSerializer;
	import com.grapefrukt.exporter.serializers.images.IImageSerializer;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class TextureExporter extends EventDispatcher {
		
		private var _queue				:FunctionQueue;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		private var _vector_serializer	:IImageSerializer;
		
		public function TextureExporter(queue:FunctionQueue, imageSerializer:IImageSerializer, fileSerializer:IFileSerializer, vectorSerializer:IImageSerializer = null) {
			_queue 				= queue;
			_image_serializer 	= imageSerializer;
			_file_serializer 	= fileSerializer;
			_vector_serializer	= vectorSerializer;
		}
		
		public function queueCollection(textureSheetCollection:TextureSheetCollection):void {		
			for each (var sheet:TextureSheet in textureSheetCollection.sheets) {
				for each (var texture:TextureBase in sheet.textures) {
					// if this isn't the textures' parent sheet, we skip it.
					if (sheet != texture.sheet) {
						//Logger.log("TextureExporter", "skipping reparented texture", "texture is added to a texture sheet that isn't it's parent", Logger.NOTICE);
						continue;
					}
					
					if (texture is VectorTexture) {
						if (!_vector_serializer) throw new Error("Cannot serialize vector data without a vector serializer");
						queue(texture, _vector_serializer);
					} else {
						queue(texture, _image_serializer);
					}
					
				}
			}
		}
		
		public function queue(texture:TextureBase, serializer:IImageSerializer):void {
			_queue.add(function():void {
				texture.extension = serializer.extension;
				Logger.log("TextureExporter", "compressing: " + texture.filenameWithPath, "", Logger.NOTICE);
				_file_serializer.serialize(texture.filenameWithPath, serializer.serialize(texture));
			});
		}
		
	}

}