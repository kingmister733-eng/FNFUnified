package data;

class AudioTrack {
    public var id:String;
    public var path:String;
    public var volume:Float;

    public function new(id:String, path:String, volume:Float = 1.0) {
        this.id = id;
        this.path = path;
        this.volume = volume;
    }
}
