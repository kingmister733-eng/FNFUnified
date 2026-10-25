package tests;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import mods.ModFormatTools;
import mods.ModFormat;

class TestModFormatTools extends TestCase {
    public function testPsychDetection() {
        assertEquals(ModFormat.PsychEngine, ModFormatTools.detect(true, false, false, false));
        assertEquals(ModFormat.PsychEngine, ModFormatTools.detect(false, true, false, false));
    }
    public function testVSliceDetection() {
        assertEquals(ModFormat.VSlice, ModFormatTools.detect(false, false, true, true));
        assertEquals(ModFormat.VSlice, ModFormatTools.detect(false, false, false, true));
    }
    public function testUnknown() {
        assertEquals(ModFormat.Unknown, ModFormatTools.detect(false, false, false, false));
    }
    public function testFromStringCase() {
        assertEquals(ModFormat.PsychEngine, ModFormatTools.fromString("PSYCH"));
        assertEquals(ModFormat.VSlice, ModFormatTools.fromString("V-Slice"));
        assertEquals(ModFormat.Unknown, ModFormatTools.fromString(null));
        assertEquals(ModFormat.Unknown, ModFormatTools.fromString(""));
        assertEquals(ModFormat.Unknown, ModFormatTools.fromString("garbage"));
    }
    public function testToStringRoundTrip() {
        assertEquals("psych", ModFormatTools.toString(ModFormat.PsychEngine));
        assertEquals("vslice", ModFormatTools.toString(ModFormat.VSlice));
        assertEquals("unknown", ModFormatTools.toString(ModFormat.Unknown));
    }
}

class TestMain {
    static function main() {
        var r = new TestRunner();
        r.add(new TestModFormatTools());
        var ok = r.run();
        if (!ok) Sys.exit(1);
    }
}
