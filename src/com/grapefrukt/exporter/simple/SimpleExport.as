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

package com.grapefrukt.exporter.simple {
	import com.grapefrukt.exporter.collections.*;
	import com.grapefrukt.exporter.debug.*;
	import com.grapefrukt.exporter.events.FunctionQueueEvent;
	import com.grapefrukt.exporter.extractors.*;
	import com.grapefrukt.exporter.filters.*;
	import com.grapefrukt.exporter.misc.*;
	import com.grapefrukt.exporter.serializers.data.*;
	import com.grapefrukt.exporter.serializers.files.*;
	import com.grapefrukt.exporter.serializers.images.*;
	import com.grapefrukt.exporter.textures.*;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * This class is mainly for usage in Flash Authoring, it encapsulates all the extracting/exporting into a 
	 * easy to use package
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class SimpleExport {
		
		private var _queue				:FunctionQueue;
		
		private var _texture_exporter	:TextureExporter;
		
		private var _data_serializer	:IDataSerializer;
		private var _image_serializer	:IImageSerializer;
		private var _file_serializer	:IFileSerializer;
		
		private var _textures			:TextureSheetCollection;
		private var _animations			:AnimationCollection;
		private var _fonts				:FontSheetCollection;
		private var _gui				:SimpleExportGui;
		
		/**
		 * Creates the SimpleExport
		 * @param	root	The GUI elements will be added to this DisplayObjectContainer
		 */
		public function SimpleExport(root:DisplayObjectContainer):void {
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
			
			// these collections hold all data as it gets parsed
			_fonts 				= new FontSheetCollection;
			_textures 			= new TextureSheetCollection;
			_animations			= new AnimationCollection;
			
			
			if(root){
				_queue.addEventListener(FunctionQueueEvent.CHANGE, 		handleQueueChange);
				_queue.addEventListener(FunctionQueueEvent.COMPLETE, 	handleQueueComplete);
				
				_gui = new SimpleExportGui;
				_gui.addEventListener(MouseEvent.CLICK, handleClickGui)
				_gui.x = 10;
				_gui.y = 10;
				
				_gui.setProgress(0);
				_gui.setText("not started");
				
				root.addChild(_gui);
			}
		}
		
		/**
		 * Starts the extracting and compressing of textures 
		 * @param	autoOutput	automatic output once extraction is complete, can't normally be used due to the filereference window that is spawned by output is required to be in respose to a mouse event
		 */
		public function export(autoOutput:Boolean = false):void {
			_queue.add(function():void {
				// start the exporting of textures (this adds all the texture exports to the queue)
				_texture_exporter.queueCollection(_textures);
				_texture_exporter.queueCollection(_fonts);
			});
			
			// the function above pushes a whole bunch of things onto the queue, when those are done
			// we initiate the final output phase
			_queue.add(function():void {
				complete(autoOutput);
			});
		}
		
		private function handleQueueChange(e:FunctionQueueEvent):void {
			_gui.setProgress( 1 - (_queue.length / _queue.peakLength));
			_gui.setText("wait");
		}
		
		private function handleQueueComplete(e:FunctionQueueEvent):void {
			_gui.setProgress(1);
			_gui.setText("click to output!");
			_gui.buttonMode = true;
		}
		
		private function handleClickGui(e:MouseEvent):void {
			if(_queue.length == 0 && _queue.peakLength > 0) output();
		}
		
		private function complete(autoOutput:Boolean = true):void {
			_queue.add(function():void {
				// by now, all the actual graphics are already output, but we still need to create the 
				// xml file that contains all the sheet data
				if (_textures.size) {
					Logger.log("SimpleExport", "exporting sheet xml");
					_file_serializer.serialize("sheets.xml", _data_serializer.serialize(_textures));
				} else {
					Logger.log("SimpleExport", "no textures to export");
				}
			});
			
			_queue.add(function():void {
				
				if (_animations.size) {
					Logger.log("SimpleExport", "exporting animation xml");
					_file_serializer.serialize("animations.xml", _data_serializer.serialize(_animations));
				} else {
					Logger.log("SimpleExport", "no animations to export");
				}
				
			});
			
			_queue.add(function():void {
				if (_fonts.size) {
					Logger.log("SimpleExport", "exporting font xml");
					for each (var fontsheet:FontSheet in _fonts.sheets){
						_file_serializer.serialize("fonts/" + fontsheet.fontName + ".xml", _data_serializer.serialize(fontsheet, true));
					}
				} else {
					Logger.log("SimpleExport", "no fonts to export");
				}
			});
			
			if (autoOutput) {
				_queue.add(function():void {
					output();
				});
			}
		}
		
		/**
		 * Starts the output, normally this will spawn a FileReference window, 
		 * so this will need to be in response to a mouse event, unless you're
		 * running in a dev enviroment
		 */
		public function output():void {
			// finally, we tell the file serializer to output
			_file_serializer.output();
		}
		
		public function get textures():TextureSheetCollection { return _textures; }
		public function get animations():AnimationCollection { return _animations; }
		public function get fonts():FontSheetCollection { return _fonts; }
	
	}
	
}