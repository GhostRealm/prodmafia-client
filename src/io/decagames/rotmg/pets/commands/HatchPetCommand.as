package io.decagames.rotmg.pets.commands {
    import com.company.assembleegameclient.editor.Command;
    
    import io.decagames.rotmg.pets.data.PetsModel;
    import io.decagames.rotmg.pets.data.vo.HatchPetVO;
    import io.decagames.rotmg.pets.data.vo.SkinVO;
    import io.decagames.rotmg.pets.popup.hatching.PetHatchingDialog;
    import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
    
    public class HatchPetCommand extends Command {
        
        
        public function HatchPetCommand() {
            super();
        }
        
        [Inject]
        public var vo: HatchPetVO;
        [Inject]
        public var openDialog: ShowPopupSignal;
        [Inject]
        public var model: PetsModel;
        
        override public function execute(): void {
            var _local1: SkinVO = this.model.getSkinVOById(this.vo.petSkin);
            var _local2: Boolean = _local1.isOwned;
            this.model.unlockSkin(this.vo.petSkin);
            this.openDialog.dispatch(new PetHatchingDialog(this.vo.petName, this.vo.petSkin, this.vo.itemType, !_local2, _local1));
        }
    }
}
