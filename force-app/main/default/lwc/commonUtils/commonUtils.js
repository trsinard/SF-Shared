
const formatPhone = (phone) => {
    if (phone) {
        phone = phone.replace(/\D/g, '');
        let match = phone.match(/(\d{0,3})(\d{0,3})(\d{0,4})(x?\d*)/);
        phone = !match[2] ? match[1] : '(' + match[1] + ') ' + match[2] + (match[3] ? '-' + match[3] : '');
        phone = match[4] ? phone + (' x' + match[4]) : phone;
    }
    return phone;
}

export {formatPhone}