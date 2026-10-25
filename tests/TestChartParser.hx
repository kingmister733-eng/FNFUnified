package tests;

import data.ChartParser;

class TestChartParser {
    static var failures:Int = 0;
    static function check(name:String, cond:Bool) {
        if (cond) trace("PASS: " + name);
        else { trace("FAIL: " + name); failures++; }
    }
    static function main() {
        var json = '{"title":"Test Song","artist":"FNF Unified","bpm":120,"source":"original-test","difficulties":[{"name":"Easy","tracks":[{"name":"player","notes":[{"time":1.0,"lane":0},{"time":2.0,"lane":1,"length":0.5,"type":"hold"}]}]}]}';
        var song = ChartParser.parse(json);
        check("song parsed", song != null);
        check("title", song.metadata.title == "Test Song");
        check("bpm", song.metadata.bpm == 120);
        check("diff count", song.difficulties.length == 1);
        check("note count", song.difficulties[0].tracks[0].notes.length == 2);

        var ok = false;
        try { ChartParser.parse('{"artist":"x","bpm":100,"difficulties":[]}'); } catch (e:Dynamic) { ok = true; }
        check("missing title throws", ok);

        ok = false;
        try { ChartParser.parse('{"title":"x","artist":"y","bpm":0,"difficulties":[]}'); } catch (e:Dynamic) { ok = true; }
        check("invalid bpm throws", ok);

        ok = false;
        try { ChartParser.parse(""); } catch (e:Dynamic) { ok = true; }
        check("empty throws", ok);

        ok = false;
        try { ChartParser.parse("{bad"); } catch (e:Dynamic) { ok = true; }
        check("invalid json throws", ok);

        var s2 = ChartParser.parse('{"title":"Empty","artist":"x","bpm":100,"difficulties":[{"name":"Easy","tracks":[{"name":"p","notes":[]}]}]}');
        check("empty notes", s2.difficulties[0].tracks[0].notes.length == 0);

        if (failures > 0) { trace("FAILURES: " + failures); Sys.exit(1); }
        trace("ALL TESTS PASSED");
    }
}
