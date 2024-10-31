import {api, LightningElement} from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class RecordPill extends NavigationMixin(LightningElement) {

    @api label;
    @api recordId;
    @api icon;

    handleClick() {
        window.open('/'+this.recordId,'_blank');
    }

    handleRemove() {
        this.dispatchEvent(new CustomEvent('remove', {}));
    }
}