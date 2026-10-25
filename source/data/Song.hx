package data;

class Song {
    public var metadata:SongMetadata;
    public var difficulties:Array<Difficulty>;
    public var audioTracks:Array<AudioTrack>;
    public var events:Array<Event>;

    public function new(metadata:SongMetadata) {
        this.metadata = metadata;
        this.difficulties = [];
        this.audioTracks = [];
        this.events = [];
    }

    public function addDifficulty(d:Difficulty):Void {
        difficulties.push(d);
    }

    public function addAudioTrack(a:AudioTrack):Void {
        audioTracks.push(a);
    }

    public function addEvent(e:Event):Void {
        events.push(e);
    }
}
