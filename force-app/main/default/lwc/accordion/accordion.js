import {api, LightningElement} from 'lwc';

export default class AccordionHeader extends LightningElement {

    @api label;
    @api icon;
    @api iconSize = 'x-small';

    _maxHeight;
    @api set maxHeight(num) {
        this._maxHeight = num;
        this.applyMaxHeightCssProperty();
    }

    get maxHeight() {
        return this._maxHeight;
    }


    _contentIndent;
    @api set contentIndent(num) {
        this._contentIndent = num;
        this.applyIndentCssProperty();
    }

    get contentIndent() {
        return this._contentIndent;
    }

    _hasRendered = false;
    renderedCallback() {
        if (!this._hasRendered) {
            this.applyMaxHeightCssProperty();
            this.applyIndentCssProperty();
            this.applyAccordionState();
            this._hasRendered = true;
        }
    }


    applyMaxHeightCssProperty() {
        this.applyCssProperty('--accordion-max-height', this.maxHeight);
    }

    applyIndentCssProperty() {
        this.applyCssProperty('--accordion-side-offset', this.contentIndent);
    }

    applyCssProperty(key, val) {
        const parentContainer = this.template.querySelector('.accordion_main-container');
        if (parentContainer && key && val) {
            parentContainer.style.setProperty(key, val);
        }
    }

    _expanded = false;
    @api set expanded(e) {
        this._expanded = e;
        this.applyAccordionState();
    }

    get expanded() {
        return this._expanded;
    }


    toggleAccordion() {
        this.expanded = !this.expanded;
    }

    applyAccordionState() {
        /*
          We do this to allow for the smooth slide opening/closing, instead of abrupt changes via if:true/false html tags.
       */
        let theContainer = this.template.querySelector('[data-id="option-container"]');
        if (theContainer) {
            if (this.expanded) {
                theContainer.classList.remove('accordion_option-container-close');
                theContainer.classList.add('accordion_option-container-open');
            } else {
                theContainer.classList.remove('accordion_option-container-open');
                theContainer.classList.add('accordion_option-container-close');
            }
        }
    }

}