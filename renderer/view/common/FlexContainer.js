import { DomElement } from "./DomElement.js";
import { loadCss } from "../../common/Utils.js";

loadCss("/renderer/view/common/FlexContainer.css");

export class FlexContainer extends DomElement {
    constructor (sTag, oInlineStyles) {
        super(sTag, oInlineStyles);

        this.addClass("flexContainer");
    }

    appendNode (oNode) {
        oNode.addClass("flexItem");
        super.appendNode(oNode);
        return this;
    }

    createItem (sTag) {
        const oItem = new DomElement(sTag)
            .addClass("flexItem");
        this.appendNode(oItem);
        return oItem;
    }
};
