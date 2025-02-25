import {api, LightningElement} from 'lwc';

export default class Modal extends LightningElement {

    @api title;
    @api hideFooter = false
    @api icon;

    handleClose() {
        this.dispatchEvent(new CustomEvent('close', {}));
    }
}