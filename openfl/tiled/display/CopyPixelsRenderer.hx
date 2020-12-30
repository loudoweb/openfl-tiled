package openfl.tiled.display;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import openfl.tiled.TiledMap;

class CopyPixelsRenderer implements Renderer {

	private var map:TiledMap;

	public function new() {
	}

	public function setTiledMap(map:TiledMap):Void {
		this.map = map;
	}

	public function drawLayer(on:Sprite, layer:Layer):Void {
		var bitmapData = new BitmapData(map.totalWidth, map.totalHeight, true, map.backgroundColor);
		var gidCounter:Int = 0;

		if(layer.visible) {
			for(y in 0...map.heightInTiles) {
				for(x in 0...map.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if(nextGID != 0) {
						var point:Point = new Point();

						switch (map.orientation) {
							case TiledMapOrientation.ORTHOGONAL:
								point = new Point(x * map.tileWidth, y * map.tileHeight);
							case TiledMapOrientation.ISOMETRIC:
								point = new Point((map.sprite.width + x - y - 1) * map.tileWidth * 0.5, (y + x) * map.tileHeight * 0.5);
							case TiledMapOrientation.STAGGERED:
								trace("not supported yet");
						}

						var tileset:Tileset = map.getTilesetByGID(nextGID);

						var rect:Rectangle = tileset.getTileRectByGID(nextGID);

						if(map.orientation == TiledMapOrientation.ISOMETRIC) {
							point.x += map.totalWidth/2;
						}

						// copy pixels
						bitmapData.copyPixels(tileset.image.texture, rect, point, null, null, true);
					}

					gidCounter++;
				}
			}
		}

		var bitmap = new Bitmap(bitmapData);

		if(map.orientation == TiledMapOrientation.ISOMETRIC) {
			bitmap.x -= map.totalWidth/2;
		}

		on.addChild(bitmap);
	}

	public function drawImageLayer(on:Sprite, imageLayer:ImageLayer):Void {
		var bitmap = new Bitmap(imageLayer.image.texture);

		on.addChild(bitmap);
	}

	public function clear(on:Sprite):Void {
		while(on.numChildren > 0){
			on.removeChildAt(0);
		}
	}
}