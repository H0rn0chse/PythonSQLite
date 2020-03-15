function HtmlElement (sTag, oOptions) {
    const oElement = document.createElement(sTag);

    if (oOptions.classes && oOptions.classes.length) {
        oOptions.classes.forEach((sClass) => {
            oElement.classList.add(sClass);
        });
    }
    if (oOptions.disabled) {
        oElement.setAttribute('disabled', "");
    }
    if (oOptions.innerText) {
        oElement.innerText = oOptions.innerText;
    }
    if (oOptions.name) {
        oElement.setAttribute('name', oOptions.name);
    }
    if (oOptions.text) {
        oElement.text = oOptions.text;
    }
    if (oOptions.type) {
        oElement.setAttribute('type', oOptions.type);
    }
    if (oOptions.value) {
        oElement.value = oOptions.value;
    }
    if (oOptions.onchange) {
        oElement.onchange = oOptions.onchange;
    }
    if (oOptions.onclick) {
        oElement.onclick = oOptions.onclick;
    }
    if (oOptions.i18n) {
        oElement.setAttribute("data-lang", oOptions.i18n);
    }

    return oElement;
}

module.exports = HtmlElement;