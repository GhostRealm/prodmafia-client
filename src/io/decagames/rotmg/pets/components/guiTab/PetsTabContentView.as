package io.decagames.rotmg.pets.components.guiTab {
    import flash.display.Bitmap;
    import flash.display.Sprite;
    
    import io.decagames.rotmg.pets.components.petStatsGrid.PetStatsGrid;
    import io.decagames.rotmg.pets.data.family.PetFamilyColors;
    import io.decagames.rotmg.pets.data.family.PetFamilyKeys;
    import io.decagames.rotmg.pets.data.rarity.PetRarityEnum;
    import io.decagames.rotmg.pets.data.vo.PetVO;
    import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;
    import io.decagames.rotmg.ui.gird.UIGrid;
    
    import kabam.rotmg.text.view.TextFieldDisplayConcrete;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class PetsTabContentView extends Sprite {
        
        
        public function PetsTabContentView() {
            petRarityTextField = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 13, false);
            petsContent = new Sprite();
            tabTitleTextField = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 15, true);
            petFamilyTextField = PetsViewAssetFactory.returnTextfield(0xb3b3b3, 13, false);
            super();
            name = "Pets";
        }
        
        public var petBitmap: Bitmap;
        public var petRarityTextField: TextFieldDisplayConcrete;
        private var petsContent: Sprite;
        private var tabTitleTextField: TextFieldDisplayConcrete;
        private var petFamilyTextField: TextFieldDisplayConcrete;
        private var petVO: PetVO;
        
        public function init(_arg_1: PetVO): void {
            this.petVO = _arg_1;
            this.petBitmap = _arg_1.getSkinBitmap();
            this.addChildren();
            this.addAbilities();
            this.positionChildren();
            this.updateTextFields();
            this.petsContent.name = "Pets";
            _arg_1.updated.add(this.onUpdate);
        }
        
        private function onUpdate(): void {
            this.updatePetBitmap();
            this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
        }
        
        private function updatePetBitmap(): void {
            this.petsContent.removeChild(this.petBitmap);
            this.petBitmap = this.petVO.getSkinBitmap();
            this.petsContent.addChild(this.petBitmap);
        }
        
        private function addAbilities(): void {
            var _local1: UIGrid = new PetStatsGrid(171, this.petVO);
            this.petsContent.addChild(_local1);
            _local1.y = 50;
        }
        
        private function getNumAbilities(): uint {
            var _local1: Boolean = this.petVO.rarity.rarityKey == PetRarityEnum.DIVINE.rarityKey || this.petVO.rarity.rarityKey == PetRarityEnum.LEGENDARY.rarityKey;
            if (_local1) {
                return 2;
            }
            return 3;
        }
        
        private function updateTextFields(): void {
            this.tabTitleTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.name)).setColor(this.petVO.rarity.color).setSize(this.petVO.name.length > 17 ? 11 : 15);
            this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.rarity.rarityKey));
            this.petFamilyTextField.setStringBuilder(new LineBuilder().setParams(PetFamilyKeys.getTranslationKey(this.petVO.family))).setColor(PetFamilyColors.getColorByFamilyKey(this.petVO.family));
        }
        
        private function addChildren(): void {
            this.petsContent.addChild(this.petBitmap);
            this.petsContent.addChild(this.tabTitleTextField);
            this.petsContent.addChild(this.petRarityTextField);
            this.petsContent.addChild(this.petFamilyTextField);
            addChild(this.petsContent);
        }
        
        private function positionChildren(): void {
            this.petBitmap.x = this.petBitmap.x - 10;
            this.petBitmap.y = this.petBitmap.y - 1;
            this.petsContent.x = 7;
            this.petsContent.y = 6;
            this.petRarityTextField.x = 46;
            this.petFamilyTextField.x = 46;
            this.tabTitleTextField.x = 46;
            this.tabTitleTextField.y = 20;
            this.petRarityTextField.y = 33;
            this.petFamilyTextField.y = 47;
        }
    }
}
