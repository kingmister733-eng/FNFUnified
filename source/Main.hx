package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
import openfl.ui.Keyboard;

class Main extends Sprite {
    private var background:Bitmap;
    private var menuLayer:Sprite;
    private var screenLayer:Sprite;
    private var statusText:TextField;
    private var clickAreas:Array<Sprite> = [];
    private var baseWidth:Float = 1280;
    private var baseHeight:Float = 720;

    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(_:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        menuLayer = new Sprite();
        screenLayer = new Sprite();
        addChild(menuLayer);
        addChild(screenLayer);

        try {
            var bitmapData:BitmapData = Assets.getBitmapData("assets/images/menu_bg.png");
            if (bitmapData != null) {
                background = new Bitmap(bitmapData);
                background.smoothing = true;
                menuLayer.addChild(background);
            } else {
                showFallback("Missing menu background image.");
            }
        } catch (e:Dynamic) {
            showFallback("Failed to load menu background: " + Std.string(e));
        }

        addMenuArea(22, 322, 455, 82, "STORY MODE", function() { showScreen("STORY MODE (placeholder)"); });
        addMenuArea(25, 405, 445, 77, "FREEPLAY", function() { showScreen("FREEPLAY (placeholder)"); });
        addMenuArea(27, 485, 430, 76, "MODS", function() { showScreen("MODS (placeholder)"); });
        addMenuArea(28, 565, 425, 78, "SETTINGS", function() { showScreen("SETTINGS (placeholder)"); });

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
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        onResize();
    }

    private function showFallback(msg:String):Void {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat("Arial", 24, 0xFF6666, true);
        tf.text = msg;
        tf.x = 20; tf.y = 20; tf.width = 600; tf.height = 60;
        addChild(tf);
    }

    private function addMenuArea(x:Float, y:Float, w:Float, h:Float, label:String, action:Void->Void):Void {
        var area = new Sprite();
        area.graphics.beginFill(0x000000, 0);
        area.graphics.drawRect(0, 0, w, h);
        area.graphics.endFill();
        area.buttonMode = true;
        area.useHandCursor = true;
        area.addEventListener(MouseEvent.CLICK, function(_) { action(); });
        menuLayer.addChild(area);
        clickAreas.push(area);
        area.name = label;
    }

    private function showScreen(title:String):Void {
        screenLayer.removeChildren();
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat("Arial", 32, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER);
        tf.text = title;
        tf.x = 40; tf.y = 40; tf.width = stage.stageWidth - 80; tf.height = 60;
        screenLayer.addChild(tf);

        var back = new Sprite();
        back.graphics.beginFill(0x333366, 0.9);
        back.graphics.drawRoundRect(0, 0, 160, 50, 10);
        back.graphics.endFill();
        back.x = 40; back.y = stage.stageHeight - 90;
        back.buttonMode = true;
        back.addEventListener(MouseEvent.CLICK, function(_) { showMenu(); });
        var bt = new TextField();
        bt.defaultTextFormat = new TextFormat("Arial", 18, 0xFFFFFF, true);
        bt.text = "BACK";
        bt.x = 45; bt.y = 12; bt.width = 150; bt.height = 30;
        back.addChild(bt);
        screenLayer.addChild(back);

        statusText.text = title;
    }

    private function showMenu():Void {
        screenLayer.removeChildren();
        statusText.text = "TAP A MENU OPTION";
    }

    private function onKeyDown(e:KeyboardEvent):Void {
        if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.BACKSPACE) {
            showMenu();
        }
    }

    private function onResize(_:Event = null):Void {
        if (stage == null) return;
        var designScaleX:Float = stage.stageWidth / baseWidth;
        var designScaleY:Float = stage.stageHeight / baseHeight;

        if (background != null) {
            var scaleX:Float = stage.stageWidth / background.bitmapData.width;
            var scaleY:Float = stage.stageHeight / background.bitmapData.height;
            var scale:Float = Math.max(scaleX, scaleY);
            background.scaleX = scale;
            background.scaleY = scale;
            background.x = (stage.stageWidth - background.width) / 2;
            background.y = (stage.stageHeight - background.height) / 2;
        }

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
