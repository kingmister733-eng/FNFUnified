package tests;

import data.*;

class TestSongData {
    static var failures:Int = 0;
    static function check(name:String, cond:Bool) {
        if (cond) trace("PASS: " + name);
        else { trace("FAIL: " + name); failures++; }
    }
    static function main() {
        var meta = new SongMetadata("Test Song", "Artist", 120, "mod", mods.ModFormat.PsychEngine);
        check("metadata valid", meta.isValid());
        check("metadata title", meta.title == "Test Song");
        check("metadata bpm", meta.bpm == 120);

        var bad = new SongMetadata("", "Artist", 0, "mod", mods.ModFormat.Unknown);
        check("bad metadata invalid", !bad.isValid());

        var song = new Song(meta);
        check("song created", song != null);
        check("empty difficulties", song.difficulties.length == 0);

        var diff = new Difficulty("Hard");
        var track = new Track("player");
        var note = new Note(1.5, 2, 0.25, "normal");
        track.addNote(note);
        diff.tracks.push(track);
        song.addDifficulty(diff);
        check("difficulty added", song.difficulties.length == 1);
        check("note lane", song.difficulties[0].tracks[0].notes[0].lane == 2);

        var audio = new AudioTrack("inst", "inst.ogg", 0.8);
        song.addAudioTrack(audio);
        check("audio added", song.audioTracks.length == 1);

        var ev = new Event(2.0, "camera_zoom", ["1.2"]);
        song.addEvent(ev);
        check("event added", song.events.length == 1);
        check("event params", song.events[0].params.length == 1);

        if (failures > 0) { trace("FAILURES: " + failures); Sys.exit(1); }
        trace("ALL TESTS PASSED");
    }
}
