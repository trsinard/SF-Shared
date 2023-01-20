import {api, LightningElement} from 'lwc';
import {empty} from "c/commonUtils";

export default class Input extends LightningElement {

    @api type;
    @api helpText;
    @api label;
    @api value;
    @api maxLength;
    @api minLength;
    @api required;
    @api formatter;
    @api min;
    @api max;


    handleChange(event) {
        this.value = event.detail.value;
        this.reportValidity();
        this.dispatchEvent(
            new CustomEvent('input',
                {
                    detail: {
                        value: this.value,
                        valid: this.checkValidity()
                    }
                }
            )
        );
    }

    handleBlur(event) {
        this.dispatchEvent(new CustomEvent('blur', {detail : {...event.detail}}));
    }
    handleFocus(event) {
        this.dispatchEvent(new CustomEvent('focus', {detail : {...event.detail}}));
    }

    reportValidity() {
        let inputCmp = this.template.querySelector('lightning-input');
        inputCmp.reportValidity();
    }

    @api checkValidity() {
        let inputCmp = this.template.querySelector('lightning-input');
        return inputCmp.checkValidity();
    }
}