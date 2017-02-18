package openfl.tiled.display;

import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import openfl.display.Tileset as OpenFlTileset;
import openfl.display.Tilemap;
import openfl.display.Tile;

class TilesheetRenderer implements Renderer {

	private var map:TiledMap;

	private var tilesheets:Map<Int, OpenFlTileset>;
	private var tileRects:Array<Rectangle>;

	public function new() {
		this.tilesheets = new Map<Int, OpenFlTileset>();
		this.tileRects = new Array<Rectangle>();
	}

	public function setTiledMap(map:TiledMap):Void {
		this.map = map;

		for(tileset in map.tilesets) {
			this.tilesheets.set(tileset.firstGID, new OpenFlTileset(tileset.image.texture));
		}
	}

	public function drawLayer(on:Dynamic, layer:Layer):Void {
		var sprite:Sprite = new Sprite();

		var tileList:Array<Tile> = new Array<Tile>();
		var gidCounter:Int = 0;

		if(layer.visible) {
			for(y in 0...map.heightInTiles) {
				for(x in 0...map.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if(nextGID != 0) {
						var point:Point = new Point();

						switch (map.orientation) {
							case TiledMapOrientation.Orthogonal:
								point = new Point(x * map.tileWidth, y * map.tileHeight);
							case TiledMapOrientation.Isometric:
								point = new Point((map.width + x - y - 1) * map.tileWidth * 0.5, (y + x) * map.tileHeight * 0.5);
						}

						var tileset:Tileset = map.getTilesetByGID(nextGID);

						var rect:Rectangle = tileset.getTileRectByGID(nextGID);

						var tileId:Int = -1;

						var foundSomething:Bool = false;

						for(r in this.tileRects) {
							if(rectEquals(r, rect)) {
								tileId = Lambda.indexOf(this.tileRects, r);

								foundSomething = true;

								break;
							}
						}

						if(!foundSomething) {
							this.tileRects.push(rect);
						}

						if(tileId < 0) {
							tileId = tilesheets.get(tileset.firstGID).addRect(rect);
						}

						// add coordinates to draw list
						tileList.push(new Tile(tileId, point.x, point.y));
					}

					gidCounter++;
				}
			}
		}

		if(map.backgroundColorSet) {
			fillBackground(sprite);
		}

		// draw layer
		for(tileset in map.tilesets) {
			trace(tileset.name);
			var openFlTileset:OpenFlTileset = tilesheets.get(tileset.firstGID);

			var tilemap:Tilemap = new Tilemap(1000, 1000, openFlTileset);
			tilemap.addTiles(tileList);

			sprite.addChild(tilemap);
		}

		on.addChild(sprite);
	}

	public function drawImageLayer(on:Dynamic, imageLayer:ImageLayer):Void {
		var sprite = new Sprite();

		var tileset:OpenFlTileset = new OpenFlTileset(imageLayer.image.texture);

		var id = tileset.addRect(new Rectangle(0, 0, imageLayer.image.width, imageLayer.image.height));

		var tilemap:Tilemap = new Tilemap(imageLayer.image.width, imageLayer.image.height, tileset);
		tilemap.addTile(new Tile(0, 0, id));

		sprite.addChild(tilemap);

		on.addChild(sprite);
	}

	public function clear(on:Dynamic):Void {
		while(on.numChildren > 0){
			on.removeChildAt(0);
		}
	}

	private function fillBackground(sprite:Sprite):Void {
		sprite.graphics.beginFill(map.backgroundColor);

		if(map.orientation == TiledMapOrientation.Orthogonal) {
			sprite.graphics.drawRect(0, 0, map.totalWidth, map.totalHeight);
		} else {
			sprite.graphics.drawRect(-map.totalWidth/2, 0, map.totalWidth, map.totalHeight);
		}

		sprite.graphics.endFill();
	}

	private function rectEquals(r1:Rectangle, r2:Rectangle):Bool {
		return r1.x == r2.x && r1.y == r2.y && r1.width == r2.width && r1.height == r2.height;
	}
}
