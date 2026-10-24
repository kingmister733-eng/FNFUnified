package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Main extends Sprite
{
    private var background:Shape;
    private var menuLayer:Sprite;

    private var title:TextField;
    private var subtitle:TextField;
    private var status:TextField;
    private var buttons:Array<Sprite>;

    private var buttonWidth:Float = 400;
    private var buttonHeight:Float = 62;

    public function new()
    {
        super();

        background = new Shape();
        addChild(background);

        menuLayer = new Sprite();
        addChild(menuLayer);

        buttons = [];

        createTitle();
        createButtons();
        createStatus();

        if (stage != null)
        {
            stage.addEventListener(Event.RESIZE, onResize);
            layoutMenu();
        }

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):Void
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        if (stage != null)
        {
            stage.addEventListener(Event.RESIZE, onResize);
            layoutMenu();
        }
    }

    private function createTitle():Void
    {
        title = new TextField();
        title.defaultTextFormat = new TextFormat(
            "_sans",
            42,
            0xFFFFFF,
            true,
            false,
            false,
            null,
            null,
            TextFormatAlign.CENTER
        );

        title.text = "FNF UNIFIED";
        title.selectable = false;
        title.mouseEnabled = false;
        title.height = 60;
        menuLayer.addChild(title);

        subtitle = new TextField();
        subtitle.defaultTextFormat = new TextFormat(
            "_sans",
            17,
            0x69E8FF,
            true,
            false,
            false,
            null,
            null,
            TextFormatAlign.CENTER
        );

        subtitle.text = "ENGINE";
        subtitle.selectable = false;
        subtitle.mouseEnabled = false;
        subtitle.height = 30;
        menuLayer.addChild(subtitle);
    }

    private function createButtons():Void
    {
        addMenuButton("STORY MODE", 0xFF4FA3, 0);
        addMenuButton("FREEPLAY", 0x36D9FF, 1);
        addMenuButton("MODS", 0xFF4FA3, 2);
        addMenuButton("SETTINGS", 0x36D9FF, 3);
    }

    private function addMenuButton(
        label:String,
        accentColor:Int,
        index:Int
    ):Void
    {
        var button = new Sprite();
        button.buttonMode = true;
        button.mouseChildren = false;

        button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):Void
        {
            onMenuButtonPressed(label);
        });

        var buttonLabel = new TextField();
        buttonLabel.defaultTextFormat = new TextFormat(
            "_sans",
            23,
            0xFFFFFF,
            true,
            false,
            false,
            null,
            null,
            TextFormatAlign.CENTER
        );

        buttonLabel.text = label;
        buttonLabel.width = buttonWidth;
        buttonLabel.height = 38;
        buttonLabel.y = 12;
        buttonLabel.selectable = false;
        buttonLabel.mouseEnabled = false;

        button.addChild(buttonLabel);

        button.name = "menu_button_" + index;
        button.graphics.lineStyle(3, accentColor, 1);
        button.graphics.beginFill(0x29263D, 1);
        button.graphics.drawRoundRect(
            0,
            0,
            buttonWidth,
            buttonHeight,
            14,
            14
        );
        button.graphics.endFill();

        // Keep the text above the button background.
        button.setChildIndex(buttonLabel, 0);

        // The background is drawn with Graphics, so the label stays visible.
        menuLayer.addChild(button);
        buttons.push(button);
    }

    private function createStatus():Void
    {
        status = new TextField();
        status.defaultTextFormat = new TextFormat(
            "_sans",
            15,
            0xAAA6C8,
            false,
            false,
            false,
            null,
            null,
            TextFormatAlign.CENTER
        );

        status.text = "SELECT A MODE";
        status.selectable = false;
        status.mouseEnabled = false;
        status.height = 30;
        menuLayer.addChild(status);
    }

    private function onMenuButtonPressed(label:String):Void
    {
        switch (label)
        {
            case "STORY MODE":
                status.text = "STORY MODE - COMING SOON";

            case "FREEPLAY":
                status.text = "FREEPLAY - COMING SOON";

            case "MODS":
                status.text = "MOD MANAGER - COMING SOON";

            case "SETTINGS":
                status.text = "SETTINGS - COMING SOON";

            default:
                status.text = "FNF UNIFIED ENGINE";
        }
    }

    private function onResize(event:Event):Void
    {
        layoutMenu();
    }

    private function layoutMenu():Void
    {
        if (stage == null)
            return;

        var screenWidth:Float = stage.stageWidth;
        var screenHeight:Float = stage.stageHeight;

        if (screenWidth <= 0 || screenHeight <= 0)
            return;

        // Draw the full-screen background.
        background.graphics.clear();
        background.graphics.beginFill(0x201E2E, 1);
        background.graphics.drawRect(
            0,
            0,
            screenWidth,
            screenHeight
        );
        background.graphics.endFill();

        // Pink and blue decorative stripes.
        background.graphics.beginFill(0xFF4FA3, 1);
        background.graphics.drawRect(
            0,
            0,
            screenWidth * 0.32,
            6
        );
        background.graphics.endFill();

        background.graphics.beginFill(0x36D9FF, 1);
        background.graphics.drawRect(
            screenWidth * 0.32,
            0,
            screenWidth * 0.68,
            6
        );
        background.graphics.endFill();

        buttonWidth = Math.min(screenWidth * 0.72, 420);

        if (buttonWidth < 180)
            buttonWidth = 180;

        var scaleFactor:Float = buttonWidth / 400;

        buttonHeight = 62 * scaleFactor;

        title.width = screenWidth * 0.9;
        title.x = screenWidth * 0.05;
        title.y = screenHeight * 0.09;
        title.height = 60;

        subtitle.width = screenWidth * 0.9;
        subtitle.x = screenWidth * 0.05;
        subtitle.y = title.y + 48;
        subtitle.height = 30;

        var gap:Float = 13 * scaleFactor;
        var totalHeight:Float =
            buttonHeight * 4 + gap * 3;

        var startY:Float = (screenHeight - totalHeight) / 2;

        // Leave room for the heading.
        if (startY < screenHeight * 0.28)
            startY = screenHeight * 0.28;

        for (i in 0...buttons.length)
        {
            var button = buttons[i];

            button.x = (screenWidth - buttonWidth) / 2;
            button.y = startY + i * (buttonHeight + gap);

            button.graphics.clear();

            var accentColor:Int;

            if (i % 2 == 0)
                accentColor = 0xFF4FA3;
            else
                accentColor = 0x36D9FF;

            button.graphics.lineStyle(3, accentColor, 1);
            button.graphics.beginFill(0x29263D, 1);
            button.graphics.drawRoundRect(
                0,
                0,
                buttonWidth,
                buttonHeight,
                14,
                14
            );
            button.graphics.endFill();

            var label:TextField = cast button.getChildAt(0);

            label.width = buttonWidth;
            label.height = buttonHeight;
            label.y = (buttonHeight - 34) / 2;

            label.defaultTextFormat = new TextFormat(
                "_sans",
                23 * scaleFactor,
                0xFFFFFF,
                true,
                false,
                false,
                null,
                null,
                TextFormatAlign.CENTER
            );

            // Reapply the format after resizing.
            var buttonText:String = label.text;
            label.text = "";
            label.text = buttonText;
        }

        status.width = screenWidth * 0.9;
        status.x = screenWidth * 0.05;
        status.y = screenHeight - 45;
        status.height = 30;
    }
}
