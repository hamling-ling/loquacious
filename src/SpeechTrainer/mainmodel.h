#ifndef MAINMODEL_H
#define MAINMODEL_H

#include <QObject>
#include <QVariant>

#include <mutex>

#include "topiclistmodel.h"
#include "countdowntimer.h"
#include "topicdrawer.h"


namespace locatious {


Q_NAMESPACE
enum MainModelState {
    IDLE,
    SELECTING,
    SPEAKING,
    TIMESUP,
};
Q_ENUM_NS(MainModelState)


class MainModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TopicListModel* topicListModel READ topicListModel NOTIFY topicListModelChanged)
    Q_PROPERTY(MainModelState state READ state NOTIFY stateChanged)
    Q_PROPERTY(QVariant remainSec READ remainSec NOTIFY remainSecChanged)

public:
    static const int kSelectionDurationSec;
    static const int kSpeechDurationSec;

    explicit MainModel(QObject *parent = nullptr);

    TopicListModel* topicListModel();
    MainModelState state();
    QVariant  remainSec();

public slots:
    void start();
    void stop();
    void next();

signals:
    void topicListModelChanged();
    void stateChanged();
    void remainSecChanged();

private:
    MainModelState               state_ = MainModelState::IDLE;
    mutable std::recursive_mutex mutex_;
    CountDownTimer               *timer_;
    TopicDrawer                  *drawer_;
    TopicListModel               topicListModel_;

    void TimerRemainSecChanged();
    void TimerElapsed();
    void GoToState(const MainModelState& nextState);
    void DrawTopics();
};

}

#endif // MAINMODEL_H
