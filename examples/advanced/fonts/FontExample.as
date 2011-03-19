package fonts {
	import com.grapefrukt.exporter.collections.*;
	import com.grapefrukt.exporter.debug.*;
	import com.grapefrukt.exporter.extractors.*;
	import com.grapefrukt.exporter.filters.*;
	import com.grapefrukt.exporter.misc.*;
	import com.grapefrukt.exporter.serializers.data.*;
	import com.grapefrukt.exporter.serializers.files.*;
	import com.grapefrukt.exporter.serializers.images.*;
	import com.grapefrukt.exporter.textures.*;
	import flash.display.*;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class FontExample extends Sprite {
		
		private var _queue				:FunctionQueue;
		
		private var _texture_exporter	:TextureExporter;
		
		private var _data_serializer	:IDataSerializer;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		private var _fonts				:FontSheetCollection;
		
		public function FontExample():void {
			
			// this class is used to call functions on a timer, not exactly necessary on these small
			// examples, but essential for larger exports (to avoid script timeouts and keep things responsive)
			_queue 				= new FunctionQueue;
			
			// these three classes are responsible for the output
			// the image serializer compresses the images
			_image_serializer 	= new PNGImageSerializer;
			// the data serializer deals with outputting the metadata such as sheet definitions and animations
			_data_serializer 	= new XMLDataSerializer;
			// the file serializer is responsible for writing the files to disk, or in this case output a zip file
			_file_serializer 	= new ZipFileSerializer;
			
			// the texture exporter uses the queue for exporting the images, this is where most of the time in 
			// the export is spent
			_texture_exporter 	= new TextureExporter(_queue, _image_serializer, _file_serializer);
			
			// this collection holds all data as it gets parsed
			_fonts 			= new FontSheetCollection;
			
			export();
		}
		
		private function export():void {
			
			_queue.add(function():void {
				// to extract a font, simply feed the FontExtractor a TextFormat with the font of your choosing
				// Flash can be picky about font names, so make sure you use the proper names!
				_fonts.add(FontExtractor.extract(new TextFormat("Impact", 120, 0x000000)));
				
				// the second parameter let's you specify which characters to include
				_fonts.add(FontExtractor.extract(new TextFormat("Georgia", 120, 0xff00ff), "0123456789"));
				
			});
			
			_queue.add(function():void {
				// start the exporting of textures (this adds all the texture exports to the queue)
				_texture_exporter.queueCollection(_fonts);
			});
			
			// the function above pushes a whole bunch of things onto the queue, when those are done
			// we initiate the final output phase
			_queue.add(function():void {
				complete();
			});
		}
		
		private function complete():void {
			
			_queue.add(function():void {
				Logger.log("Main", "exporting font xml");
				// by now, all the actual graphics are already output, but we still need to create the 
				// xml file that contains all the sheet data
				for each (var fontsheet:FontSheet in _fonts.sheets){
					_file_serializer.serialize("fonts/" + fontsheet.fontName + ".xml", _data_serializer.serialize(fontsheet, true));
				}
			});
			
			_queue.add(function():void {
				// finally, we tell the file serializer to output, in this case spit out a zip file using filereference and fzip
				_file_serializer.output();
			});
		}
	
	}
	
}