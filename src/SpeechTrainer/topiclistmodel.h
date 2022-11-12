#ifndef TOPICLISTMODEL_H
#define TOPICLISTMODEL_H

#include <mutex>

#include <QObject>
#include <QAbstractListModel>
#include <QList>

#include "topicitemmodel.h"


class TopicListModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum ModelRoles {
        TopicIdRole = Qt::UserRole + 1,
        SentenceRole
    };

    explicit TopicListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    Q_INVOKABLE TopicItemModel* get(quint32 index) const;
    void addTopics(const std::array<std::string, 5> &topics);
    void clear();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QList<TopicItemModel*>       list_;
    mutable std::recursive_mutex mutex_;
};

#endif // TOPICLISTMODEL_H
