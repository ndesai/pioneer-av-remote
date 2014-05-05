import QtQuick 2.2
import QtQuick.LocalStorage 2.0

QtObject {
    id: root
    property string databaseName : "PersistentStorage"
    property string databaseVersion : "1.0"

    function insert(key, value, callback)
    {
        var db = LocalStorage.openDatabaseSync(root.databaseName,
                                               root.databaseVersion,
                                               "",
                                               1000000);

        db.transaction(function(tx) {
            console.log("insert() - tx ok");
            tx.executeSql('CREATE TABLE IF NOT EXISTS PD(key TEXT, value TEXT)');

            var rs = tx.executeSql('SELECT * FROM PD WHERE key = ?', [key]);
            var callbackReturn = 0;
            if(rs.rows.length > 0)
            {
                try {
                    callbackReturn = tx.executeSql('UPDATE PD SET value = \'' + value + '\' WHERE key = \'' + key + '\'');
                } catch(ex)
                {
                    console.log("Failed to update, error is " + ex);
                }
            } else
            {
                callbackReturn = tx.executeSql('INSERT INTO PD VALUES(?, ?)', [key, value]);
            }
            if(callback) callback(callbackReturn);
        })
    }

    function getValue(key, callback)
    {
        var db = LocalStorage.openDatabaseSync(root.databaseName,
                                               root.databaseVersion,
                                               "",
                                               1000000);

        db.transaction(function(tx) {
            console.log("getValue() - tx ok");
            tx.executeSql('CREATE TABLE IF NOT EXISTS PD(key TEXT, value TEXT)');
            var rs = tx.executeSql('SELECT * FROM PD WHERE key = \'' + key + '\'');
            var ret = ""
            for(var i = 0; i < rs.rows.length; i++) {
                ret = rs.rows.item(i).value
            }
            if(callback)
                callback(ret);
        })
    }
}
