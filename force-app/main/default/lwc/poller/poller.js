import {api, LightningElement, track} from 'lwc';

export default class Poller extends LightningElement {

    _intervalSeconds = 1;
    @api get intervalSeconds() {
        return this._intervalSeconds;
    }

    set intervalSeconds(secs) {
        this._intervalSeconds = secs;
        if (this._interval) {
            this.clearInterval();
            this.setInterval();
        }

    }

    @api activityTimeoutSeconds = 3;
    lastActivity = null;
    initialized = false;
    _interval;
    @api debug = false;
    @track lastExecution = new Date();
    activityTimedOut = false;

    disconnectedCallback() {
        this.clearInterval();
    }

    connectedCallback() {
        this.handleActivity();
        if (!this.initialized) {
            [
                'click',
                'touchstart',
                'keydown',
                'wheel'
            ].forEach(evt =>
                window.addEventListener(evt, this.handleActivity.bind(this), false)
            );
            this.initialized = true;
        }
        this.setInterval()
    }

    clearInterval() {
        if (this._interval) {
            clearInterval(this._interval);
        }
        this._interval = null;
    }

    setInterval() {
        if (!this._interval) {
            let activityTimeout = this.activityTimeoutSeconds ? this.activityTimeoutSeconds * 1000 : null;
            this._interval = setInterval(() => {
                let activityCutoff = new Date(this.lastActivity.getTime() + activityTimeout);
                if (this.activityTimeoutSeconds && new Date() <= activityCutoff) {
                    this.activityTimedOut = false;
                    this.lastExecution = new Date();
                    this.dispatchEvent(new CustomEvent('interval', {}));
                } else {
                    this.activityTimedOut = true;
                }
            }, this.intervalSeconds * 1000);
        }
    }

    handleActivity() {
        this.lastActivity = new Date();
    }
}