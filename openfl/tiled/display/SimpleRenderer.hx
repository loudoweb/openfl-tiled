package openfl.tiled.display;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.geom.Point;
import openfl.tiled.ImageLayer;
import openfl.tiled.Layer;
import openfl.tiled.TiledMap;

/**
 * This simple renderer use standard display list.
 * Use case: when the project still doesn't use atlas texture.
 * @author Ludovic Bas
 */
class SimpleRenderer implements Renderer 
{
	private var map:TiledMap;

	public function new() 
	{
		
	}
	
	
	/* INTERFACE openfl.tiled.display.Renderer */
	
	public function setTiledMap(map:TiledMap):Void 
	{
		this.map = map;
	}
	
	public function drawLayer(on:Dynamic, layer:Layer):Void 
	{
		var bitmapData:BitmapData = null;
		var gidCounter:Int = 0;

		
		if(layer.visible) {
			for(y in 0...map.heightInTiles) {
				for(x in 0...map.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;

					if (nextGID > 0)
					{
						var tileset:Tileset = map.getTilesetByGID(nextGID);
						
						var tilename = tileset.getImageName(nextGID);
						
						var bitmap = new Bitmap(Assets.getBitmapData(tilename), PixelSnapping.ALWAYS, true);
					
						var point:Point = new Point();

						switch (map.orientation) {
							case TiledMapOrientation.ORTHOGONAL:
								point = new Point(x * map.tileWidth, y * map.tileHeight);
							case TiledMapOrientation.ISOMETRIC:
								point = new Point(( x - y) * map.tileWidth * 0.5 + (map.heightInTiles - 1) * map.tileWidth * 0.5, (y + x) * map.tileHeight * 0.5 - (bitmap.height - map.tileHeight));
							case TiledMapOrientation.STAGGERED:
								if ((y & 1) == 0)
								{
									point = new Point(x * map.tileWidth, y * map.tileHeight * 0.5 - (bitmap.height - map.tileHeight));
								}else{
									point = new Point(x * map.tileWidth + 0.5 * map.tileWidth , y * map.tileHeight * 0.5 - (bitmap.height - map.tileHeight));
								}
								
						}

						
						on.addChild(bitmap);
						
						bitmap.x = point.x;
						bitmap.y = point.y;
						trace(nextGID, tilename, bitmap.x, bitmap.y);
					}
					
					gidCounter++;
				}
			}
		}

	}
	
	public function drawImageLayer(on:Dynamic, imageLayer:ImageLayer):Void {
		trace("there is no image layer in this renderer");
	}

	public function clear(on:Dynamic):Void {
		if(on.numChildren > 0){
			on.removeAllChildren();
		}
	}
	
}