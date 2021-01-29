#ifndef FAVORITE_H
#define FAVORITE_H

#include <QObject>

class Favorite : public QObject
{
private:
    Q_OBJECT
    int number;
    QStringList favorites;

public:
    explicit Favorite(QObject *parent = nullptr);

signals:

public slots:
    bool addFavorite(QString name, QString luminance, QString colorTemperature);
    void deleteFavorite(QString name);
    int getNumber();
    QStringList getFavorites();
    void storeFavoriteName(QString name);
    QString getFavoriteName();
    void clearFavoriteName();
};

#endif // FAVORITE_H
