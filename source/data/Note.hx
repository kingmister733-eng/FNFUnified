package data;

class Note {
    public var time:Float;
    public var lane:Int;
    public var length:Float;
    public var type:String;

    public function new(time:Float, lane:Int, length:Float = 0, type:String = "normal") {
        this.time = time;
        this.lane = lane;
        this.length = length;
        this.type = type;
    }
}
