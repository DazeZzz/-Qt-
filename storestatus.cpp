#include "storestatus.h"
#include "databaseconnection.h"

StoreStatus::StoreStatus(QObject *parent) : QObject(parent)
{
    DatabaseConnection db;
    QString statement = "select * "
                        "from intelligentlighting.status;";
    QStringList result = db.executeStatement(statement, 2);
    if (result.isEmpty()) {
        luminance = 0;
        colorTemperature = 0;
    } else {
        luminance = result[0].toDouble();
        colorTemperature = result[1].toDouble();
    }
}

void StoreStatus::storeStatus(double luminance, double colorTemperature) {
    QString statement1 = "delete from intelligentlighting.status;";
    QString statement2 = QString("insert into "
                                "intelligentlighting.status "
                        "values(%1, %2);").arg(luminance).arg(colorTemperature);
    DatabaseConnection db;
    db.queryStatement(statement1);
    db.queryStatement(statement2);
}

double StoreStatus::getLuminance() {
    return luminance;
}

double StoreStatus::getColorTemperature() {
    return colorTemperature;
}
