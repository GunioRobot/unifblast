package library {
	import flash.display.*;
	import flash.utils.getDefinitionByName;
	public class AssetHandler {
		
		public var stageWidth: int;
		public var stageHeight: int;
		
		public function AssetHandler(sw:int, sh:int):void {
			stageWidth = sw;
			stageHeight = sh;
		}
		
		public function Image(AssetsName:String):Bitmap {
			var classdef:Class = getDefinitionByName(AssetsName) as Class;
			var a:BitmapData = new classdef(stageWidth, stageHeight);
			return new Bitmap(a);
		}
		
		public function Movie(AssetsName:String):MovieClip {
			var classdef:Class = getDefinitionByName(AssetsName) as Class;
			return new classdef();
		}
		
	}
}