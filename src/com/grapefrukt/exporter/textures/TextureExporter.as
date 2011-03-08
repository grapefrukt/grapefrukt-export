package com.grapefrukt.exporter.textures {
	import com.grapefrukt.exporter.collections.TextureSheetCollection;
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.FunctionQueue;
	import com.grapefrukt.exporter.serializers.files.IFileSerializer;
	import com.grapefrukt.exporter.serializers.images.IImageSerializer;
	
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Martin Jonasson (m@grapefrukt.com)
	 */
	public class TextureExporter extends EventDispatcher {
		
		private var _queue				:FunctionQueue;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		public function TextureExporter(queue:FunctionQueue, imageSerializer:IImageSerializer, fileSerializer:IFileSerializer) {
			_queue = queue;
			_image_serializer = imageSerializer;
			_file_serializer = fileSerializer;
		}
		
		public function queueCollection(textureSheetCollection:TextureSheetCollection):void {		
			for each (var sheet:TextureSheet in textureSheetCollection.sheets) {
				for each (var texture:Texture in sheet.textures) {
					// if this isn't the textures' parent sheet, we skip it.
					if (sheet != texture.sheet) {
						//Logger.log("TextureExporter", "skipping reparented texture", "texture is added to a texture sheet that isn't it's parent", Logger.NOTICE);
						continue;
					}
					
					queue(texture);
				}
			}
		}
		
		public function queue(texture:Texture):void {
			_queue.add(function():void {
				Logger.log("TextureExporter", "compressing: " + texture.filenameWithPath, "", Logger.NOTICE);
				_file_serializer.serialize(texture.filenameWithPath, _image_serializer.serialize(texture.bitmap));
			});
		}
		
	}

}