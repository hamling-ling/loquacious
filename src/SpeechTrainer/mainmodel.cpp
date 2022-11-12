#include "mainmodel.h"

#include <QDebug>


using namespace std;


namespace locatious {


const int MainModel::kSelectionDurationSec = 60;
const int MainModel::kSpeechDurationSec = 120;

//debug
//const int MainModel::kSelectionDurationSec = 1;
//const int MainModel::kSpeechDurationSec = 2;


MainModel::MainModel(QObject *parent)
    : QObject{parent},
      timer_(new CountDownTimer(this)),
      drawer_(new TopicDrawer(this))
{
    connect( timer_,
             &CountDownTimer::remainSecChanged,
             this,
             &MainModel::TimerRemainSecChanged);

    connect( timer_,
             &CountDownTimer::elapsed,
             this,
             &MainModel::TimerElapsed);

    drawer_->LoadTopics(":/topics.txt");
}


TopicListModel* MainModel::topicListModel() {
    return &topicListModel_;
}


MainModelState MainModel::state()
{
    lock_guard<recursive_mutex> lock(mutex_);
    return state_;
}


QVariant MainModel::remainSec()
{
    lock_guard<recursive_mutex> lock(mutex_);
    return QVariant::fromValue(timer_->remainSec());
}


void MainModel::start()
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(MainModelState::IDLE != state_ && MainModelState::TIMESUP != state_ ) {
        return;
    }

    timer_->stop();
    if(MainModelState::IDLE == state_) {
        // 初回実行ならトピックを更新
        DrawTopics();
        // 選択タイムに突入
        GoToState(MainModelState::SELECTING);
        timer_->start(kSelectionDurationSec);
    } else {
        // リトライならトピックそのままでスピーチタイムに突入
        GoToState(MainModelState::SPEAKING);
        timer_->start(kSpeechDurationSec);
    }
}


void MainModel::stop()
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(MainModelState::IDLE == state_ && MainModelState::TIMESUP == state_ ) {
        qDebug() << "ignored";
        return;
    }

    GoToState(MainModelState::IDLE);
    timer_->stop();
}

void MainModel::next()
{
    stop();
    start();
}


void MainModel::TimerRemainSecChanged()
{
    emit remainSecChanged();
}


void MainModel::TimerElapsed()
{
    lock_guard<recursive_mutex> lock(mutex_);
    switch(state_) {
    case MainModelState::SELECTING:
        GoToState(MainModelState::SPEAKING);
        timer_->start(kSpeechDurationSec);
        break;
    case MainModelState::SPEAKING:
        GoToState(MainModelState::TIMESUP);
        break;
    case MainModelState::IDLE:
    default:
        timer_->stop();
        break;
    }
}


void MainModel::GoToState(const MainModelState& nextState)
{
    if(nextState == state_) {
        return;
    }
    qDebug() << "state" << state_ << " -> " << nextState;
    state_ = nextState;
    emit stateChanged();
}

void MainModel::DrawTopics()
{
    array<string, 5> tps;
    drawer_->DrawTopics(tps);
    topicListModel_.addTopics(tps);
}


} // namespace
