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

import openfl.display.BitmapData;

class Tile {

	public var gid(default, null):Int;
	public var parent(default, null):Layer;
	public var width(get, null):Int;
	public var height(get, null):Int;


    public var gid(default, null):Int;
    public var parent(default, null):Layer;
    public var width(get_width, null):Int;
    public var height(get_height, null):Int;

    public var flipped_diag(default, null):Bool;
    public var flipped_horz(default, null):Bool;
    public var flipped_vert(default, null):Bool;

    // transform data
    private var dirty:Bool;
    private var _transform:Matrix;
    public var transform(get_transform, null):Matrix;

    private function new(gid:Int, parent:Layer) {
        this.parent = parent;
        this.dirty = true;
        // extract data from gid
        this.flipped_horz = (gid & FLIPPED_HORIZONTALLY_FLAG) != 0;
        this.flipped_vert = (gid & FLIPPED_VERTICALLY_FLAG) != 0;
        this.flipped_diag = (gid & FLIPPED_DIAGONALLY_FLAG) != 0;
        this.gid = gid & ~(FLIPPED_HORIZONTALLY_FLAG | FLIPPED_VERTICALLY_FLAG | FLIPPED_DIAGONALLY_FLAG);
    }

    public static function fromGID(gid:Int, parent:Layer):Tile {
        return new Tile(gid, parent);
    }

    private function get_width():Int {
        return parent.parent.tileWidth;
    }

    private function get_height():Int {
        return parent.parent.tileHeight;
    }

    public function get_transform():Matrix
    {
        //_transform = [1, 0, 0, 1];
        if (dirty) 
        {
            _transform = new Matrix();
            var dirX:Int = flipped_horz ? -1 : 1;
            var dirY:Int = flipped_vert ? -1 : 1;
            var sx:Float = 1;//scaleX * layer.tilesheet.scale;
            var sy:Float = 1;//scaleY * layer.tilesheet.scale;
            if(flipped_diag) {
                var radians:Float = 90 * Math.PI / 180;
                _transform.a = dirX * Math.cos(radians) * sx;
                _transform.b = dirY * Math.sin(radians) * sy;
                _transform.c = - dirX * - Math.sin(radians) * sx;
                _transform.d = dirY * Math.cos(radians) * sy;
                _transform.tx = flipped_horz ? parent.parent.tileWidth : 0;
                _transform.ty = flipped_vert ? parent.parent.tileHeight : 0;
                //trace('diag', dirX, dirY, _transform);
            } else {
                _transform.a = dirX * sx;
                _transform.b = 0;
                _transform.c = 0;
                _transform.d = dirY * sy;
                _transform.tx = flipped_horz ? parent.parent.tileWidth : 0;
                _transform.ty = flipped_vert ? parent.parent.tileHeight : 0;
            }
            //_transform.tx *= sx;
            //_transform.ty *= sy;
            dirty = false;
        }
            //    _transform[0] = dirX * cos * sx;
            //    _transform[1] = dirX * sin * sx;
            //    _transform[2] = -dirY * sin * sy;
            //    _transform[3] = dirY * cos * sy;
            //}
            //    _transform[0] = dirX * sx;
            //    _transform[1] = 0;
            //    _transform[2] = 0;
            //    _transform[3] = dirY * sy;
        return _transform;
    }


}
