package data;

class Difficulty {
    public var name:String;
    public var tracks:Array<Track>;

    public function new(name:String) {
        this.name = name;
        this.tracks = [];
    }
}
