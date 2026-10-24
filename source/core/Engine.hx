package core;

class Engine {
    public static inline var ENGINE_NAME:String = "FNF Unified Engine";
    public static inline var ENGINE_VERSION:String = "0.1.0";

    public function new() {
        trace(ENGINE_NAME + " v" + ENGINE_VERSION);
    }
}
