package animations {
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
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class SpriteSheetAnimationExample extends Sprite {
		
		private var _queue				:FunctionQueue;
		
		private var _texture_exporter	:TextureExporter;
		
		private var _data_serializer	:IDataSerializer;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		private var _textures			:TextureSheetCollection;
		
		public function SpriteSheetAnimationExample():void {
			
			// this class is used to call functions on a timer, not exactly necessary on these small
			// examples, but essential for larger exports (to avoid script timeouts and keep things responsive)
			_queue 				= new FunctionQueue;
			
			// these three classes are responsible for the output
			// the image serializer compresses the images
			_image_serializer 	= new PNGImageSerializer;
			// the data serializer deals with outputting the metadata such as sheet definitions and animations
			_data_serializer 	= new XMLDataSerializer(_image_serializer);
			// the file serializer is responsible for writing the files to disk, or in this case output a zip file
			_file_serializer 	= new ZipFileSerializer;
			
			// the texture exporter uses the queue for exporting the images, this is where most of the time in 
			// the export is spent
			_texture_exporter 	= new TextureExporter(_queue, _image_serializer, _file_serializer);
			
			// these collections hold all data as it gets parsed
			_textures 			= new TextureSheetCollection;
			
			export();
		}
		
		private function export():void {
			
			_queue.add(function():void {
				
				// to extract a sheet-animation, put your movieclip in a container and use the extractor on that
				var container:Sprite = new Sprite;
				var darwin:DancingDarwin = new DancingDarwin;
				darwin.name = "dancing_darwin";
				
				container.addChild(darwin);
				
				// note that this doesn't involve the animation extractor at all, that's only for the xml-based animations
				_textures.add(TextureExtractor.extract(container));
				
				
				// this technique will extract from any "subclip" that has animation:
				_textures.add(TextureExtractor.extract(new ManyDancingDarwins));
				
			});
			
			_queue.add(function():void {
				// start the exporting of textures (this adds all the texture exports to the queue)
				_texture_exporter.queueCollection(_textures);
			});
			
			// the function above pushes a whole bunch of things onto the queue, when those are done
			// we initiate the final output phase
			_queue.add(function():void {
				complete();
			});
		}
		
		private function complete():void {
			
			_queue.add(function():void {
				// by now, all the actual graphics are already output, but we still need to create the 
				// xml file that contains all the sheet data
				Logger.log("Main", "exporting sheet xml");
				_file_serializer.serialize("sheets.xml", _data_serializer.serialize(_textures));
			});
			
			_queue.add(function():void {
				// finally, we tell the file serializer to output, in this case spit out a zip file using filereference and fzip
				_file_serializer.output();
			});
		}
	
	}
	
}