#include "dictumlistmodel.h"


using namespace std;


DictumListModel::DictumListModel(QObject *parent)
    : QAbstractListModel{parent}
{

}


QHash<int, QByteArray> DictumListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]       = "dictumId";
    roles[SentenceRole] = "sentence";
    roles[KeywordsRole] = "keywords";

    return roles;
}


int DictumListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    lock_guard<recursive_mutex> lock(mutex_);
    return list_.length();
}


QVariant DictumListModel::data(const QModelIndex & index, int role) const {

    lock_guard<recursive_mutex> lock(mutex_);

    if (index.row() < 0 || index.row() >= list_.length())
        return QVariant();

     const Dictum* obj = list_[index.row()];
     if(obj != nullptr) {
         if (IdRole == role) {
             return obj->textId();
         } else if (SentenceRole == role) {
             return obj->text();
         } else if(KeywordsRole == role) {
             return obj->keywords();
         }
     }

    return QVariant();
}


Dictum *DictumListModel::get(quint32 index) const
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(list_.length() <= index) {
        return nullptr;
    }

    return list_[index];
}


void DictumListModel::setDictums(const QList<Dictum*> &list)
{
    lock_guard<recursive_mutex> lock(mutex_);

    clear();

    beginInsertRows(QModelIndex(), 0, list.size()-1 );
    list_.append(list);
    endInsertRows();
}


void DictumListModel::clear()
{
    lock_guard<recursive_mutex> lock(mutex_);

    int len = list_.length();
    if(len == 0) {
        return;
    }

    beginRemoveRows(QModelIndex(), 0, len-1);
    removeRows(0, len);
    list_.clear();
    endRemoveRows();
}

