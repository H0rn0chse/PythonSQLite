import { Table } from "../common/Table.js";
import { DatabaseManager } from "./DatabaseManager.js";

class _LinesTable extends Table {
    constructor () {
        super("lines");

        this.references = {
            persons: "Billing",
            types: "Type",
            accounts: "Account"
        };
    }

    createSqlAction (oLine) {
        oLine.Account = oLine.Account === undefined ? null : oLine.Account;
        const sSql = `
        INSERT INTO Lines
            (Receipt, Value, Billing, Type, Account)
        Values ($Receipt, $Value, $Billing, $Type, $Account)
        `;
        return DatabaseManager.get()
            .prepare(sSql)
            .run(oLine);
    }

    readSqlAction (oObject) {
        let sSql;
        if (oObject.ID) {
            sSql = `
            SELECT *
            FROM Lines
            WHERE ID = $ID
            `;
        } else {
            sSql = `
            SELECT *
            FROM Lines
            WHERE Receipt = $Receipt
            `;
        }
        return DatabaseManager.get()
            .prepare(sSql)
            .all(oObject);
    }

    updateSqlAction (oLine) {
        const sSql = `
        UPDATE Lines
        SET Receipt=$Receipt, Value=$Value, Billing=$Billing, Type=$Type
        WHERE ID=$ID
        `;
        return DatabaseManager.get()
            .prepare(sSql)
            .run(oLine);
    }

    deleteSqlAction (oObject) {
        let sSql;
        if (oObject.ID) {
            sSql = `
            DELETE
            FROM Lines
            WHERE ID = $ID
            `;
        } else {
            sSql = `
            DELETE
            FROM Lines
            WHERE Receipt = $Receipt
            `;
        }
        return DatabaseManager.get()
            .prepare(sSql)
            .run(oObject);
    }
}

export const LinesTable = new _LinesTable();
