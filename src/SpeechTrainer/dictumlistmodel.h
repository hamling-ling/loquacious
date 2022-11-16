#ifndef DICTUMLISTMODEL_H
#define DICTUMLISTMODEL_H

#include <mutex>

#include <QObject>
#include <QAbstractListModel>
#include <QList>

#include "dictum.h"


class DictumListModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum DictumRoles {
        IdRole = Qt::UserRole + 1,
        SentenceRole,
        KeywordsRole,
    };

    explicit DictumListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE Dictum* get(quint32 index) const;
    void setDictums(const QList<Dictum*> &list);
    void clear();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Dictum*>               list_;
    mutable std::recursive_mutex mutex_;
};

#endif // DICTUMLISTMODEL_H
