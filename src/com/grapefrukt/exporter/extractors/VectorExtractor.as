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

package com.grapefrukt.exporter.extractors {
	import com.codeazur.as3swf.data.SWFSymbol;
	import com.codeazur.as3swf.exporters.SVGShapeExporter;
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.tags.TagDefineShape;
	import com.codeazur.as3swf.tags.TagDefineSprite;
	import com.codeazur.as3swf.tags.TagPlaceObject2;
	import com.codeazur.as3swf.tags.TagSymbolClass;
	import com.grapefrukt.exporter.debug.Logger;
	import com.grapefrukt.exporter.misc.Child;
	import com.grapefrukt.exporter.textures.TextureSheet;
	import com.grapefrukt.exporter.textures.VectorTexture;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class VectorExtractor extends ExtractorBase {
		
		private static var _swf		:SWF;
		private static var _symbols	:Vector.<SWFSymbol>;
		private static var _exporter:SVGShapeExporter;
		
		public static function init(loaderInfo:LoaderInfo):void {
			_swf = new SWF(loaderInfo.bytes);
			var symboltag:TagSymbolClass;
			for (var i:uint = 0; i < _swf.tags.length; i++) {
				symboltag = _swf.tags[i] as TagSymbolClass;
				if (symboltag) break;
			}
			_symbols = symboltag.symbols;
			
			_exporter = new SVGShapeExporter(_swf);
		}
		
		public static function extract(sheet:DisplayObjectContainer, ignore:Array = null):TextureSheet {
			Logger.log("VectorExtractor", "extracting", ChildFinder.getName(sheet));
			return childrenToSheet(sheet, getChildren(sheet, ignore));
		}
		
		public static function extractFromClasses(sheetName:String, ...rest):TextureSheet {
			return extract(classesToSheetSprite(sheetName, rest));
		}
		
		private static function childrenToSheet(target:DisplayObjectContainer, children:Vector.<Child>):TextureSheet {
			var sheet:TextureSheet = new TextureSheet(ChildFinder.getName(target));
			for each(var child:Child in children) {
				var t:VectorTexture = extractSingle(child.name, target.getChildByName(child.name));
				if(t) sheet.add(t);
			}
			return sheet;
		}
		
		public static function extractSingle(name:String, target:DisplayObject):VectorTexture {
			if (!_swf) throw new Error("No SWF bytecode parsed, run init() first")
			
			var name:String = getQualifiedClassName(target);
			for (var i:int = 0; i < _symbols.length; i++) {
				if (_symbols[i].name == name) {
					var shapeTag:TagDefineShape = getSymbolShapeDefinition(_symbols[i])
					
					var zindex:uint = 0;
					if (target.parent) zindex = target.parent.getChildIndex(target);
					return new VectorTexture(target.name, zindex, shapeTag);
				}
			}
			return null;
		}
		
			
		static private function getSymbolShapeDefinition(symbol:SWFSymbol):TagDefineShape {
			var tagDefineSprite:TagDefineSprite = _swf.getCharacter(symbol.tagId) as TagDefineSprite;
			
			var tagPlaceObject:TagPlaceObject2;
			for (var i:int = 0; i < tagDefineSprite.tags.length; i++) {
				if ((tagPlaceObject = tagDefineSprite.tags[i] as TagPlaceObject2)) {
					return _swf.getCharacter(tagPlaceObject.characterId) as TagDefineShape;
				}
			}
			return null;
		}
		
		static public function get swf():SWF { return _swf; }
		
	}

}