
package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

class Main extends Sprite
{
    public function new()
    {
        super();

        var title = new TextField();
        title.defaultTextFormat = new TextFormat(
            "_sans",
            32,
            0xFFFFFF,
            true
        );
        title.text = "FNF Unified Engine";
        title.width = 700;
        title.x = 40;
        title.y = 100;
        addChild(title);

        var status = new TextField();
        status.defaultTextFormat = new TextFormat(
            "_sans",
            20,
            0xAAAAFF
        );
        status.text = "Engine prototype v0.1.0";
        status.width = 700;
        status.x = 40;
        status.y = 160;
        addChild(status);
    }
}
