package basic {
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
	 * @author Martin Jonasson (m@webbfarbror.se)
	 */
	public class BasicExample extends Sprite {
		
		private var _queue				:FunctionQueue;
		
		private var _texture_exporter	:TextureExporter;
		
		private var _data_serializer	:IDataSerializer;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		private var _textures			:TextureSheetCollection;
		
		public function BasicExample():void {
			
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
				var smoke:TextureSheet = TextureExtractor.extract(new SmokeAll);
				
				// by default everything in that display object is parsed and extracted, 
				// you can ignore specific children using the ignore parameter:
				var smokeWithoutFour:TextureSheet = TextureExtractor.extract(new SmokeAll, ["smoke4"]);
				
				// another default setting is that all children are exported at 100% scaling
				// set respectScale to true to use whatever scaling you've set in the parent 
				var smokeWithScale:TextureSheet = TextureExtractor.extract(new SmokeAll, null, true);
				
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
				var manualSmoke:TextureSheet = TextureExtractor.extract(smokeContainerSprite);
				
				// that can however be a bit talkative, so there's a convenience function to deal with that:
				// this is the method i personally prefer
				var classesToSheetSmoke:TextureSheet = TextureExtractor.extractFromClasses("smoke", SmokeParticle1, SmokeParticle2, SmokeParticle3, SmokeParticle4);
				// this variation also figures out the names for you, if you don't like the naming scheme, feel free to change it!
				
				// worth noting is that the exporter will respect any filters/effects you have on your graphics.
				var effectsSmoke:TextureSheet = TextureExtractor.extract(new SmokeWithEffects);
				// sheets will be named automatically using the class name fed to the extractor, but you can change it manually
				effectsSmoke.name = "smoke_with_effects";
				
				// finally, you will need to add the textures you exported to your sheet, for clarity, let's just use the two last ones
				_textures.add(classesToSheetSmoke);
				_textures.add(effectsSmoke);
				
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