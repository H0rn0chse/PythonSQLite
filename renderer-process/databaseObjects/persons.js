function Persons () {
    let aPersons;
    const aRefreshCallbacks = [];
    const oListenerCallbacks = {};
    let bRequestPending = true;

    window.ipcRenderer.sendTo(window.iDatabaseId, "read-persons");
    window.ipcRenderer.on("read-persons", (oEvent, oResult) => {
        aPersons = oResult;

        aRefreshCallbacks.forEach(function (fnCallback) {
            fnCallback();
        });
        aRefreshCallbacks.splice(0, aRefreshCallbacks.length);

        Object.keys(oListenerCallbacks).forEach((sKey) => {
            oListenerCallbacks[sKey](aPersons);
        });

        bRequestPending = false;
    });
    return {
        get: function () {
            if (Array.isArray(aPersons)) {
                aPersons.sort((a, b) => {
                    if (parseInt(a.ID, 10) < parseInt(b.ID, 10)) {
                        return -1;
                    }
                    if (parseInt(a.ID, 10) > parseInt(b.ID, 10)) {
                        return 1;
                    }
                    return 0;
                });
            }
            return aPersons;
        },
        update: function (aPersons) {
            window.ipcRenderer.sendTo(window.iDatabaseId, "write-persons", aPersons);
        },
        refresh: function (fnCallback) {
            aRefreshCallbacks.push(fnCallback);
            if (!bRequestPending) {
                bRequestPending = true;
                window.ipcRenderer.sendTo(window.iDatabaseId, "read-persons");
            }
        },
        add: function (oPerson) {
            window.ipcRenderer.sendTo(window.iDatabaseId, "write-persons", oPerson);
        },
        addListener: function (sName, fnCallback) {
            oListenerCallbacks[sName] = fnCallback;
        },
        removeListener: function (sName) {
            delete oListenerCallbacks[sName];
        }
    };
};

const oInstance = new Persons();
module.exports = oInstance;
