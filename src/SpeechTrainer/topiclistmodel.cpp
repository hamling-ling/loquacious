#include "topiclistmodel.h"


using namespace std;


TopicListModel::TopicListModel(QObject *parent)
    : QAbstractListModel{parent}
{

}


QHash<int, QByteArray> TopicListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TopicIdRole]  = "topicId";
    roles[SentenceRole] = "topicSentence";

    return roles;
}


int TopicListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    lock_guard<recursive_mutex> lock(mutex_);
    return list_.count();
}


QVariant TopicListModel::data(const QModelIndex & index, int role) const {

    lock_guard<recursive_mutex> lock(mutex_);

    if (index.row() < 0 || index.row() >= list_.length())
        return QVariant();

     const TopicItemModel* obj = list_[index.row()];
     if(obj != nullptr) {
         if (TopicIdRole == role) {
             return obj->topicId();
         } else if (SentenceRole == role) {
             return obj->topicSentence();
         }
     }

    return QVariant();
}


TopicItemModel *TopicListModel::get(quint32 index) const
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(list_.length() <= index) {
        return nullptr;
    }

    return list_[index];
}


void TopicListModel::addTopics(const array<string, 5> &topics)
{
    lock_guard<recursive_mutex> lock(mutex_);

    clear();

    beginInsertRows(QModelIndex(), 0, topics.size()-1 );
    for(int i = 0; i < topics.size(); i++) {
        TopicItemModel* item = new TopicItemModel(i, topics[i], this);
        list_.append(item);
    }
    endInsertRows();
}


void TopicListModel::clear()
{
    lock_guard<recursive_mutex> lock(mutex_);

    int len = list_.length();
    if(len == 0) {
        return;
    }

    beginRemoveRows(QModelIndex(), 0, len-1);
    removeRows(0, len);
    qDeleteAll(list_.begin(), list_.end());
    list_.clear();
    endRemoveRows();
}

