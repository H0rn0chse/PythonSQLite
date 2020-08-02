import { EventBus } from "../../EventBus.js";
import { DatabaseModel } from "../common/DatabaseModel.js";
import { UnixToInput, InputToUnix } from "../../../assets/dateFormatter.js";
import { deepClone } from "../../common/Utils.js";

class _ReceiptModel extends DatabaseModel {
    constructor (oData) {
        super(oData, "receipts", true);
    }

    read (iId) {
        const oData = {
            ID: iId
        };
        EventBus.sendToDatabase(`${this.table}-read`, oData);
    }

    addEntry () {
        const oEntry = {
            Date: "",
            Account: 1,
            Comment: "",
            Store: 1
        };
        EventBus.sendToDatabase("receipts-create", oEntry);

        this.mergeObjectIntoData(oEntry);
    }

    deleteEntry (iId) {
        const oEntry = {
            ID: iId
        };
        EventBus.sendToDatabase("receipts-delete", oEntry);
    }

    processCreate (oEvent, oData) {
        this.set(["ID"], oData.lastInsertRowid);
    }

    processRead (oEvent, oData) {
        oData.Date = UnixToInput(oData.Date);
        this.mergeObjectIntoData(oData);
        console.log("ReceiptsModel loaded");
    }

    processUpdate () {}

    setDate (sDate) {
        this.set(["Date"], sDate);
        this.save();
    }

    setAccount (iAccount) {
        this.set(["Account"], iAccount);
        this.save();
    }

    setComment (sComment) {
        this.set(["Comment"], sComment);
        this.save();
    }

    setStore (iStore) {
        this.set(["Store"], iStore);
        this.save();
    }

    save () {
        const oEntry = deepClone(this.get([]));
        oEntry.Date = InputToUnix(oEntry.Date);
        EventBus.sendToDatabase("receipts-update", oEntry);
    }
}

export const ReceiptModel = new _ReceiptModel({
});
