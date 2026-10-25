package data;

import haxe.Json;
import mods.ModFormat;

class ChartParser {
    public static function parse(jsonText:String):Song {
        if (jsonText == null || StringTools.trim(jsonText).length == 0) {
            throw "ChartParser: empty input";
        }
        var obj:Dynamic = null;
        try {
            obj = Json.parse(jsonText);
        } catch (e:Dynamic) {
            throw "ChartParser: invalid JSON";
        }
        if (obj == null) throw "ChartParser: null document";

        var title:String = Reflect.field(obj, "title");
        var artist:String = Reflect.field(obj, "artist");
        var bpm:Float = Reflect.field(obj, "bpm");
        var source:String = Reflect.field(obj, "source");
        if (source == null) source = "unknown";

        if (title == null || StringTools.trim(title).length == 0) throw "ChartParser: missing title";
        if (artist == null) artist = "Unknown";
        if (bpm == null || bpm <= 0) throw "ChartParser: invalid bpm";

        var meta = new SongMetadata(title, artist, bpm, source, ModFormat.Unknown);
        var song = new Song(meta);

        var diffs:Dynamic = Reflect.field(obj, "difficulties");
        if (diffs != null) {
            for (d in (diffs : Array<Dynamic>)) {
                var dname:String = Reflect.field(d, "name");
                if (dname == null) dname = "default";
                var diff = new Difficulty(dname);
                var tracks:Dynamic = Reflect.field(d, "tracks");
                if (tracks != null) {
                    for (t in (tracks : Array<Dynamic>)) {
                        var tname:String = Reflect.field(t, "name");
                        if (tname == null) tname = "track";
                        var track = new Track(tname);
                        var notes:Dynamic = Reflect.field(t, "notes");
                        if (notes != null) {
                            for (n in (notes : Array<Dynamic>)) {
                                var time:Float = Reflect.field(n, "time");
                                var lane:Int = Reflect.field(n, "lane");
                                var length:Float = Reflect.field(n, "length");
                                var type:String = Reflect.field(n, "type");
                                if (length == null) length = 0;
                                if (type == null) type = "normal";
                                track.addNote(new Note(time, lane, length, type));
                            }
                        }
                        diff.tracks.push(track);
                    }
                }
                song.addDifficulty(diff);
            }
        }
        return song;
    }
}
