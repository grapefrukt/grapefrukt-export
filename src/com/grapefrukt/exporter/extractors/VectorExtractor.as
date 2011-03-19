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
	import com.grapefrukt.exporter.textures.BitmapTexture;
	import com.grapefrukt.exporter.textures.TextureSheet;
	import com.grapefrukt.exporter.textures.VectorTexture;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
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