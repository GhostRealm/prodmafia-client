package kabam.rotmg.promotions.view {
import com.company.assembleegameclient.util.PaymentMethod;

import flash.display.Sprite;

import kabam.lib.ui.GroupMappedSignal;
import kabam.rotmg.promotions.view.components.TransparentButton;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebChoosePaymentTypeDialog extends Sprite {

    public static var hifiBeginnerOfferMoneyFrameEmbed:Class = WebChoosePaymentTypeDialog_hifiBeginnerOfferMoneyFrameEmbed;

    public function WebChoosePaymentTypeDialog() {
        super();
        this.close = new Signal();
        this.select = new GroupMappedSignal("click", String);
        this.makeBackground();
        this.makeCloseButton();
        this.makePaymentSelection();
    }
    public var close:Signal;
    public var select:GroupMappedSignal;
    public var paypal:Sprite;
    public var creditCard:Sprite;
    public var google:Sprite;

    public function centerOnScreen():void {
        x = (stage.stageWidth - width) * 0.5;
        y = (stage.stageHeight - height) * 0.5 - 5;
    }

    private function makeBackground():void {
        addChild(new hifiBeginnerOfferMoneyFrameEmbed());
    }

    private function makeCloseButton():void {
        var _local1:Sprite = this.makeTransparentButton(550, 30, 30, 30);
        this.close = new NativeMappedSignal(_local1, "click");
    }

    private function makePaymentSelection():void {
        this.paypal = this.makeTransparentButton(220, 3 * 60, 3 * 60, 35);
        this.creditCard = this.makeTransparentButton(220, 224, 3 * 60, 35);
        this.google = this.makeTransparentButton(220, 268, 3 * 60, 35);
        this.select.map(this.paypal, PaymentMethod.PAYPAL_METHOD.label_);
        this.select.map(this.creditCard, PaymentMethod.CREDITS_METHOD.label_);
        this.select.map(this.google, PaymentMethod.GO_METHOD.label_);
    }

    private function makeTransparentButton(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):Sprite {
        var _local5:TransparentButton = new TransparentButton(_arg_1, _arg_2, _arg_3, _arg_4);
        addChild(_local5);
        return _local5;
    }
}
}
