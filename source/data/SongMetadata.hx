package data;

import mods.ModFormat;

class SongMetadata {
    public var title:String;
    public var artist:String;
    public var bpm:Float;
    public var source:String;
    public var originalFormat:ModFormat;

    public function new(title:String, artist:String, bpm:Float, source:String, originalFormat:ModFormat) {
        this.title = title;
        this.artist = artist;
        this.bpm = bpm;
        this.source = source;
        this.originalFormat = originalFormat;
    }

    public function isValid():Bool {
        return title != null && title.length > 0 && bpm > 0;
    }
}
