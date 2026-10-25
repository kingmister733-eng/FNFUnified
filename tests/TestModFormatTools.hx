package tests;

import mods.ModFormatTools;
import mods.ModFormat;

class TestModFormatTools {
    static var failures:Int = 0;
    static function check(name:String, cond:Bool) {
        if (cond) trace("PASS: " + name);
        else { trace("FAIL: " + name); failures++; }
    }
    static function main() {
        check("psych data", ModFormatTools.detect(true, false, false, false) == ModFormat.PsychEngine);
        check("psych scripts", ModFormatTools.detect(false, true, false, false) == ModFormat.PsychEngine);
        check("vslice manifest+assets", ModFormatTools.detect(false, false, true, true) == ModFormat.VSlice);
        check("vslice assets", ModFormatTools.detect(false, false, false, true) == ModFormat.VSlice);
        check("unknown empty", ModFormatTools.detect(false, false, false, false) == ModFormat.Unknown);
        check("fromString psych", ModFormatTools.fromString("PSYCH") == ModFormat.PsychEngine);
        check("fromString vslice", ModFormatTools.fromString("V-Slice") == ModFormat.VSlice);
        check("fromString null", ModFormatTools.fromString(null) == ModFormat.Unknown);
        check("fromString empty", ModFormatTools.fromString("") == ModFormat.Unknown);
        check("fromString garbage", ModFormatTools.fromString("garbage") == ModFormat.Unknown);
        check("toString", ModFormatTools.toString(ModFormat.PsychEngine) == "psych");
        if (failures > 0) { trace("FAILURES: " + failures); Sys.exit(1); }
        trace("ALL TESTS PASSED");
    }
}
