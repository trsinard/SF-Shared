import {api, LightningElement} from 'lwc';
import {isEmpty} from "c/parsingUtil";

export default class InputPhone extends LightningElement {

    @api label;
    @api required;
    @api enforceFormat;
    @api value;
    validationMessage;

    connectedCallback() {
        this.value = this.value ? this.value : "";
        this.formatPhone(this.value);
    }

    formatPhone(inputPhone) {
        inputPhone = inputPhone == null ? "" : inputPhone.replace(/\D/g, '');

        let formattedPhone = inputPhone.match(/(\d{0,3})(\d{0,3})(\d{0,4})(x?\d*)/);
        if(this.enforceFormat) {
            inputPhone = !formattedPhone[2] ? formattedPhone[1] : '(' + formattedPhone[1] + ') ' + formattedPhone[2] + (formattedPhone[3] ? '-' + formattedPhone[3] : '');
        } else {
            inputPhone = formattedPhone[1] + formattedPhone[2] + formattedPhone[3];
        }
        inputPhone = formattedPhone[4] ? inputPhone + (' x' + formattedPhone[4]) : inputPhone;
        return inputPhone;
    }

    handleChange(event) {
        this.value = this.formatPhone(event.detail.value);
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

    @api reportValidity() {
        this.validationMessage = '';
        if(!((this.required && !isEmpty(this.value)) || !this.required)) {
            this.validationMessage = "Complete this field."
        } else if(this.value) {
            let lengthValidWithFormat = this.enforceFormat && ((this.value.length === 14 || this.value.length === 0) || (this.value.length > 16 && this.value.length <= 22));
            let lengthValidWithoutFormat = !this.enforceFormat && ((this.value.length === 10 || this.value.length === 0) || (this.value.length > 12 && this.value.length <= 18));
            if(!lengthValidWithFormat && !lengthValidWithoutFormat) {
                this.validationMessage = "Invalid phone value.";
            }
        }
        let inputCmp = this.template.querySelector('lightning-input');
        inputCmp.setCustomValidity(this.validationMessage);
        inputCmp.reportValidity();
    }

    @api checkValidity() {
        return isEmpty(this.validationMessage);
    }
}