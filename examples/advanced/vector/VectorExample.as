package vector {
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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.UncaughtErrorEvent;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class VectorExample extends Sprite {
		
		private var _queue				:FunctionQueue;
		
		private var _texture_exporter	:TextureExporter;
		
		private var _data_serializer	:IDataSerializer;
		private var _image_serializer	:IImageSerializer;
		private var _vector_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		private var _textures			:TextureSheetCollection;
		
		public function VectorExample():void {
			
			// first we need to feed the extractor a reference to this swf's loaderinfo, it'll use that to 
			// parse the actual bytecode of the symbols to extract.
			VectorExtractor.init(loaderInfo);
			
			// this class is used to call functions on a timer, not exactly necessary on these small
			// examples, but essential for larger exports (to avoid script timeouts and keep things responsive)
			_queue 				= new FunctionQueue;
			
			// uses the flash player 10.1 UncaughtErrorEvent to stop the queue on errors
			// comment these lines if compiling for earlier versions
			loaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, function(e:UncaughtErrorEvent):void {
				_queue.stop();
			});
			
			// these four classes are responsible for the output
			// the image serializer compresses the bitmap images
			_image_serializer 	= new PNGImageSerializer;
			// the vector serializer deals with the vector images
			_vector_serializer = new SVGImageSerializer;
			
			// the data serializer deals with outputting the metadata such as sheet definitions and animations
			_data_serializer 	= new XMLDataSerializer;
			// the file serializer is responsible for writing the files to disk, or in this case output a zip file
			_file_serializer 	= new ZipFileSerializer;
			
			
			
			// the texture exporter uses the queue for exporting the images, this is where most of the time in 
			// the export is spent
			_texture_exporter 	= new TextureExporter(_queue, _image_serializer, _file_serializer, _vector_serializer);
			
			// this collection holds all data as it gets parsed
			_textures 			= new TextureSheetCollection;
			
			export();
		}
		
		private function export():void {
						
			_queue.add(function():void {

				// there are multiple ways to export your assets, one is to group them together
				// in a Sprite in Flash authoring and use the extractor on that. 
				// note that you will need to name all the children you want to be exported, 
				// as unnamed children will be ignored!
				var smoke:TextureSheet = VectorExtractor.extract(new SmokeAll);
				
				// by default everything in that display object is parsed and extracted, 
				// you can ignore specific children using the ignore parameter:
				var smokeWithoutFour:TextureSheet = VectorExtractor.extract(new SmokeAll, ["smoke4"]);
				
				// you can also use code to put together your graphics before extracting
				// first, we need a container
				var smokeContainerSprite:Sprite = new Sprite();
				// then we create the sprite we want to export
				var smokeSprite:SmokeParticle1 = new SmokeParticle1;
				// don't forget to name it!
				smokeSprite.name = "smoke1";
				// then we add it to the container
				smokeContainerSprite.addChild(smokeSprite);
				// and use the extractor:
				var manualSmoke:TextureSheet = VectorExtractor.extract(smokeContainerSprite);
				
				// that can however be a bit talkative, so there's a convenience function to deal with that:
				// this is the method i personally prefer
				var classesToSheetSmoke:TextureSheet = VectorExtractor.extractFromClasses("smoke", SmokeParticle1, SmokeParticle2, SmokeParticle3, SmokeParticle4);
				// this variation also figures out the names for you, if you don't like the naming scheme, feel free to change it!
				
				_textures.add(classesToSheetSmoke);
				
				// let's try adding a complex image too for good measure.
				_textures.add(VectorExtractor.extractFromClasses("tomundtfrank", TomUndtFrank));
				
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