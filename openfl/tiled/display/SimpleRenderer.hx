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
trace(map.heightInTiles, map.widthInTiles);
trace(map.tileWidth, map.tileHeight);
trace(map.sprite.width, map.sprite.height);
		if(layer.visible) {
			for(y in 0...map.heightInTiles) {
				for(x in 0...map.widthInTiles) {
					var nextGID = layer.tiles[gidCounter].gid;
					trace(nextGID);
					if (nextGID > 0)
					{
						
					
						var point:Point = new Point();

						switch (map.orientation) {
							case TiledMapOrientation.Orthogonal:
								point = new Point(x * map.tileWidth, y * map.tileHeight);
							case TiledMapOrientation.Isometric:
								point = new Point(( x - y - 1) * map.tileWidth * 0.5, (y + x) * map.tileHeight * 0.5);
						}

						var tileset:Tileset = map.getTilesetByGID(nextGID);
						
						var tilename = tileset.getImageName(nextGID);

						trace(tilename);
						
						var bitmap = new Bitmap(Assets.getBitmapData(tilename), PixelSnapping.ALWAYS, true);
						on.addChild(bitmap);
						
						bitmap.x = point.x;
						bitmap.y = point.y;

						/*if(map.orientation == TiledMapOrientation.Isometric) {
							point.x += map.totalWidth/2;
						}
						
						if(map.orientation == TiledMapOrientation.Isometric) {
							bitmap.x -= map.totalWidth/2;
						}*/
						trace(point);
					}
					
					gidCounter++;
				}
			}
		}

		trace(on.numChildren);
		

		
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