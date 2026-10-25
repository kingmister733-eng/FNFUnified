package tests;

class TestMain {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new TestModFormatTools());
        var ok = r.run();
        if (!ok) Sys.exit(1);
    }
}
