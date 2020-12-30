package openfl.tiled;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class TileData 
{
	public var id:Int;
		
	public var property:PropertyTile;
	public var image:String;
	public var objectGroup:TiledObjectGroup;
	public var type:String;
	
	public var zorder:Int;

	public function new(id:Int, type:String, image:String, objectgroup:TiledObjectGroup, property:PropertyTile, zorder:Int ) 
	{
		this.id = id;
		this.type = type;
		this.image = image;
		this.objectGroup = objectgroup;
		this.property = property;
		this.zorder = zorder;
	}
	
	public function getProperty(name:String):String
	{
		return property.get(name);
	}
	
	public function hasProperty(name:String):Bool
	{
		return property != null ? property.exists(name) : false;
	}
	
	public static function fromGenericXml(xml:Xml, zorder:Int = 0):TileData
	{
		var id:Int = Std.parseInt(xml.get("id"));
		var type = xml.get("type");
		var property:PropertyTile = null;
		var image:String = '';
		var objectgroup:TiledObjectGroup = null;
			

		for (element in xml) {

			if(Helper.isValidElement(element)) {
				if (element.nodeName == "properties") {
					var properties:Map<String, String> = new Map<String, String>();
					for (property in element) {
						if (!Helper.isValidElement(property)) {
							continue;
						}
						properties.set(property.get("name"), property.get("value"));
					}
					property = new PropertyTile(id, properties);
					
				}else if (element.nodeName == "image") {
					
					image = element.get("source");
					
				}else if (element.nodeName == "objectgroup") {
					
					objectgroup = TiledObjectGroup.fromGenericXml(element);
					
				}
			}
		}
		return new TileData(id, type, image, objectgroup, property, zorder);
	}
	
}