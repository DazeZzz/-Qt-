#include "favorite.h"
#include "databaseconnection.h"
#include "QDebug"

Favorite::Favorite(QObject *parent) : QObject(parent)
{
    DatabaseConnection db;
    QString statement = "select * "
                        "from intelligentlighting.favorite";
//    qDebug() << statement;
    favorites = db.executeStatement(statement, 3);
    number = favorites.length() / 3;
//    qDebug() << favorites;
}

bool Favorite::addFavorite(QString name, QString luminance, QString colorTemperature) {
    DatabaseConnection db;
    QString statement = QString("insert into intelligentlighting.favorite "
                                "values('%1', '%2', '%3')").arg(name).arg(luminance).arg(colorTemperature);
//    qDebug() << statement;
    return db.queryStatement(statement);
}

void Favorite::deleteFavorite(QString name) {
    DatabaseConnection db;
    QString statement = QString("delete from intelligentlighting.favorite "
                                "where name_favorite = '%1'").arg(name);
    db.queryStatement(statement);
}

void Favorite::storeFavoriteName(QString name) {
    DatabaseConnection db;
    QString statement = QString("insert into intelligentlighting.favorite_name "
                                "values('%1')").arg(name);
    db.queryStatement(statement);
}

QString Favorite::getFavoriteName() {
    DatabaseConnection db;
    QString statement = QString("select * "
                                "from intelligentlighting.favorite_name");
//    qDebug() << statement;
    QStringList result = db.executeStatement(statement, 1);
    if (result.isEmpty())
        return nullptr;
    else
        return result[0];
}

void Favorite::clearFavoriteName() {
    DatabaseConnection db;
    QString statement = "delete from intelligentlighting.favorite_name";
    db.queryStatement(statement);
}

int Favorite::getNumber() {
    return number;
}
QStringList Favorite::getFavorites() {
    return favorites;
}
