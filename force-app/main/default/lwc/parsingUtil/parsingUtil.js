const getDeepValue = (obj, path) => {

    path = normalizeKeyPath(path);
    if (!path) {
        return null;
    }

    let properties = path.split('.');
    for (let i = 0; i < properties.length; ++i) {
        let property = properties[i];
        if (property && obj && property in obj) {
            obj = obj[property];
        } else {
            return null;
        }
    }
    return obj;
}

const normalizeKeyPath = (str) => {
    let result = null;
    if (str) {
        result = str
            .replace(/\[(\w+)\]/g, '.$1')   //Replace [#] with #
            .replace(/^\./, '');            //Remove starting period.
    }
    return result;
}


const clone = (obj, deep) => {

    if (obj == null) {
        return null;
    } else if (deep || (!deep && !Array.isArray(obj) && typeof obj !== 'object')) {
        return JSON.parse(JSON.stringify(obj));
    } else if (Array.isArray(obj)) {
        return [...obj];
    } else if (typeof obj === 'object') {
        return {...obj};
    }
    return obj;
}

const isEmpty = (val) => {
    return val == null || (typeof val === 'object' && Object.entries(val).length === 0 && val.constructor === Object) || (Array.isArray(val) &&  val.length === 0) || String(val).trim() === "";
}
export {getDeepValue, clone, isEmpty}