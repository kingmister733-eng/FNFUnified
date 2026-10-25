package mods;

enum ModFormat {
    Unknown;
    PsychEngine;
    VSlice;
}

class ModFormatTools {
    public static function fromString(value:String):ModFormat {
        if (value == null) return Unknown;
        var lower:String = value.toLowerCase();
        if (lower == "psych" || lower == "psychengine" || lower == "psych engine") return PsychEngine;
        if (lower == "vslice" || lower == "v-slice" || lower == "official" || lower == "funkin") return VSlice;
        return Unknown;
    }

    public static function toString(format:ModFormat):String {
        return switch (format) {
            case PsychEngine: "psych";
            case VSlice: "vslice";
            case Unknown: "unknown";
        };
    }

    public static function detect(hasDataFolder:Bool, hasScriptsFolder:Bool, hasManifest:Bool, hasAssetsFolder:Bool):ModFormat {
        if (hasManifest && hasAssetsFolder) return VSlice;
        if (hasDataFolder) return PsychEngine;
        if (hasScriptsFolder && !hasManifest) return PsychEngine;
        if (hasAssetsFolder) return VSlice;
        return Unknown;
    }
}
