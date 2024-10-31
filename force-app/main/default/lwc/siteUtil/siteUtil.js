import getIsAuthenticated from "@salesforce/apex/SiteController.isAuthenticated";
import getNetworkDetails from "@salesforce/apex/SiteController.getNetwork";
import getNetworkBasePath from "@salesforce/apex/SiteController.getNetworkBasePath";


const calloutIsAuthenticated = () => {
    return getIsAuthenticated().then(result => {
        return result;
    }).catch(error => {
        console.error('ERROR: SiteUtil: ', error);
    });
};

const calloutGetNetworkDetails = () => {
    return getNetworkDetails().then(result => {
        return result;
    }).catch(error => {
        console.error('ERROR: SiteUtil: ', error);
    });
};

const calloutGetNetworkBasePath = (networkPrefix) => {
    return getNetworkBasePath({networkPrefix: networkPrefix}).then(result => {
        return result;
    }).catch(error => {
        console.error('ERROR: SiteUtil: ', error);
    });
};


class SiteUtil {
    static isAuthenticated = async () => {
        return await calloutIsAuthenticated();
    };

    static getNetwork = async () => {
        return await calloutGetNetworkDetails();
    }

    static getNetworkBasePath = async (networkPrefix) => {
        return await calloutGetNetworkBasePath(networkPrefix);
    }

    static isSitePreview() {
        let loc = document.URL ? document.URL : loc = window.location.hostname;
        loc = loc.toLowerCase();
        return loc.indexOf('sitepreview') >= 0 || loc.indexOf('livepreview') >= 0;
    }

}

export {SiteUtil}