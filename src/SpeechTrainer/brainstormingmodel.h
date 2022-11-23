#ifndef BRAINSTORMINGMODEL_H
#define BRAINSTORMINGMODEL_H

#include <QObject>
#include <QVariant>
#include <QList>
#include <QMap>
#include <QSet>

#include <mutex>

#include "dictumlistmodel.h"


namespace loquatious {


class BrainstormingModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(DictumListModel* dictumListModel READ dictumListModel NOTIFY dictumListModelChanged)
    Q_PROPERTY(const QStringList keywords READ keywords NOTIFY keywordsChanged)

public:
    explicit BrainstormingModel(QObject *parent = nullptr);

    DictumListModel* dictumListModel();
    const QStringList keywords() const;

public slots:
    bool loadData();
    void select(const QString& keyword);

signals:
    void dictumListModelChanged();
    void keywordsChanged();

private:
    mutable std::recursive_mutex mutex_;
    QMap<int, Dictum*>           allDictums_;
    DictumListModel              dictumListModel_;
    QStringList                  keywords_;
    QMap<QString, QSet<int>>     keyMap_;
};

}

#endif // BRAINSTORMINGMODEL_H
