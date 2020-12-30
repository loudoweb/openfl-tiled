// Copyright (C) 2013 Christopher "Kasoki" Kaster
//
// This file is part of "openfl-tiled". <http://github.com/Kasoki/openfl-tiled>
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
package openfl.tiled;

import haxe.io.Path;

class ImageLayer {

	public var tiledMap(default, null):TiledMap;
	public var name(default, null):String;
	public var opacity(default, null):Float;
	public var visible(default, null):Bool;
	public var offsetx(default, null):Int;
	public var offsety(default, null):Int;

	public var properties(default, null):Map<String, String>;
	public var image(default, null):TilesetImage;

	private function new(tiledMap:TiledMap, name:String, opacity:Float, visible:Bool,
			properties:Map<String, String>,
			image:TilesetImage,
			offsetx:Int, offsety:Int) {
				
		this.tiledMap = tiledMap;
		this.name = name;
		this.opacity = opacity;
		this.visible = visible;
		this.properties = properties;
		this.image = image;
		this.offsetx = offsetx;
		this.offsety = offsety;
	}

	public static function fromGenericXml(tiledMap:TiledMap, xml:Xml):ImageLayer {
		var name:String = xml.get("name");
		var opacity:Float = xml.exists("opacity") ? Std.parseFloat(xml.get("opacity")) : 1.0;
		var visible:Bool = xml.exists("visible") ? Std.parseInt(xml.get("visible")) == 1 : false;
		var offsetx:Int = xml.exists("offsetx") ? Std.parseInt(xml.get("offsetx")) : 0;
		var offsety:Int = xml.exists("offsety") ? Std.parseInt(xml.get("offsety")) : 0;

		var properties = new Map<String, String>();
		var image:TilesetImage = null;

		for(child in xml.elements()) {
			if(Helper.isValidElement(child)) {
				if(child.nodeName == "properties") {
					for(property in child) {
						if(Helper.isValidElement(property)) {
							properties.set(property.get("name"), property.get("value"));
						}
					}
				}
			}

			if (child.nodeName == "image") {
				//var prefix = Path.directory(tiledMap.path) + "/";
				//image = new TilesetImage(child.get("source"), child.get("trans"), prefix);
				image = new TilesetImage(child.get("source"), child.get("trans"));
			}
		}

		return new ImageLayer(tiledMap, name, opacity, visible, properties, image, offsetx, offsety);
	}
}