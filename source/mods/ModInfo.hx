package mods;

class ModInfo {
    public var id:String;
    public var name:String;
    public var version:String;
    public var format:String;

    public function new(id:String, name:String, version:String, format:String) {
        this.id = id;
        this.name = name;
        this.version = version;
        this.format = format;
    }
}
