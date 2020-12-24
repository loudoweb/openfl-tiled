package openfl.tiled.display;
import openfl.display.Sprite;

interface Renderer {
	public function setTiledMap(map:TiledMap):Void;
	public function drawLayer(on:Sprite, layer:Layer):Void;
	public function drawImageLayer(on:Dynamic, imageLayer:ImageLayer):Void;
	public function clear(on:Dynamic):Void;
}