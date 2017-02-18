package;

import openfl.display.Bitmap;
import openfl.Lib;

import openfl.tiled.TiledMap;

import openfl.Assets;
import openfl.display.FPS;

class Main {
	public static function main():Void {
		var map = TiledMap.fromAssets("assets/perspective_walls.tmx");
		
		Lib.current.stage.addChild(map);
		Lib.current.stage.addChild(new FPS());
	}
}
