package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

class Main extends Sprite {
    private var background:Bitmap;
    private var clickAreas:Array<Sprite> = [];
    private var statusText:TextField;
    private var baseWidth:Float = 1280;
    private var baseHeight:Float = 720;

    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(_:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        var bitmapData:BitmapData = Assets.getBitmapData("assets/images/menu_bg.png");
        background = new Bitmap(bitmapData);
        background.smoothing = true;
        addChild(background);

        // Invisible touch areas aligned with the four menu choices in the artwork.
        addMenuArea(22, 322, 455, 82, "STORY MODE");
        addMenuArea(25, 405, 445, 77, "FREEPLAY");
        addMenuArea(27, 485, 430, 76, "MODS");
        addMenuArea(28, 565, 425, 78, "SETTINGS");

        statusText = new TextField();
        statusText.defaultTextFormat = new TextFormat("Arial", 20, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER);
        statusText.selectable = false;
        statusText.mouseEnabled = false;
        statusText.text = "TAP A MENU OPTION";
        statusText.background = true;
        statusText.backgroundColor = 0x101020;
        statusText.alpha = 0.92;
        addChild(statusText);

        stage.addEventListener(Event.RESIZE, onResize);
        onResize();
    }

    private function addMenuArea(x:Float, y:Float, w:Float, h:Float, label:String):Void {
        var area = new Sprite();
        area.graphics.beginFill(0xFFFFFF, 0.01);
        area.graphics.drawRect(0, 0, w, h);
        area.graphics.endFill();
        area.x = x;
        area.y = y;
        area.buttonMode = true;
        area.useHandCursor = true;
        area.addEventListener(MouseEvent.CLICK, function(_:MouseEvent):Void {
            onMenuSelected(label);
        });
        clickAreas.push(area);
        addChild(area);
    }

    private function onMenuSelected(label:String):Void {
        switch (label) {
            case "STORY MODE":
                showStatus("STORY MODE  -  COMING SOON");
            case "FREEPLAY":
                showStatus("FREEPLAY  -  SONG SELECT IS NEXT");
            case "MODS":
                showStatus("MODS  -  MOD LOADER IS NEXT");
            case "SETTINGS":
                showStatus("SETTINGS  -  OPTIONS ARE COMING SOON");
            default:
                showStatus(label);
        }
    }

    private function showStatus(message:String):Void {
        statusText.text = message;
        statusText.width = Math.min(stage.stageWidth - 32, 760);
        statusText.height = 42;
        statusText.x = (stage.stageWidth - statusText.width) / 2;
        statusText.y = stage.stageHeight - 54;
    }

    private function onResize(_:Event = null):Void {
        if (stage == null || background == null) return;

        var scaleX:Float = stage.stageWidth / background.bitmapData.width;
        var scaleY:Float = stage.stageHeight / background.bitmapData.height;
        var scale:Float = Math.max(scaleX, scaleY);
        background.scaleX = scale;
        background.scaleY = scale;
        background.x = (stage.stageWidth - background.width) / 2;
        background.y = (stage.stageHeight - background.height) / 2;

        // Keep touch zones in the same coordinate system as the 1280x720 design.
        var designScaleX:Float = stage.stageWidth / baseWidth;
        var designScaleY:Float = stage.stageHeight / baseHeight;
        var zones:Array<Array<Float>> = [
            [22, 322, 455, 82],
            [25, 405, 445, 77],
            [27, 485, 430, 76],
            [28, 565, 425, 78]
        ];
        for (i in 0...clickAreas.length) {
            clickAreas[i].x = zones[i][0] * designScaleX;
            clickAreas[i].y = zones[i][1] * designScaleY;
            clickAreas[i].scaleX = designScaleX;
            clickAreas[i].scaleY = designScaleY;
        }

        if (statusText != null) {
            statusText.width = Math.min(stage.stageWidth - 32, 760 * designScaleX);
            statusText.height = 42 * designScaleY;
            statusText.x = (stage.stageWidth - statusText.width) / 2;
            statusText.y = stage.stageHeight - 54 * designScaleY;
        }
    }
}
