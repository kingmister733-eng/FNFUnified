package data;

class Track {
    public var name:String;
    public var notes:Array<Note>;

    public function new(name:String) {
        this.name = name;
        this.notes = [];
    }

    public function addNote(n:Note):Void {
        notes.push(n);
    }
}
