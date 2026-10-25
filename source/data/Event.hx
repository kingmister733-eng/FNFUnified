package data;

class Event {
    public var time:Float;
    public var name:String;
    public var params:Array<String>;

    public function new(time:Float, name:String, params:Array<String> = null) {
        this.time = time;
        this.name = name;
        this.params = params == null ? [] : params;
    }
}
