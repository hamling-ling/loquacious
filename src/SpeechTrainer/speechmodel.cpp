#include "speechmodel.h"

#include <QDebug>


using namespace std;


namespace loquatious {


const int SpeechModel::kSelectionDurationSec = 60;
const int SpeechModel::kSpeechDurationSec = 120;

//debug
//const int MainModel::kSelectionDurationSec = 1;
//const int MainModel::kSpeechDurationSec = 2;


SpeechModel::SpeechModel(QObject *parent)
    : QObject{parent},
      timer_(new CountDownTimer(this)),
      drawer_(new TopicDrawer(this))
{
    connect( timer_,
             &CountDownTimer::remainSecChanged,
             this,
             &SpeechModel::TimerRemainSecChanged);

    connect( timer_,
             &CountDownTimer::elapsed,
             this,
             &SpeechModel::TimerElapsed);

    drawer_->LoadTopics(":/topics.txt");
}


TopicListModel* SpeechModel::topicListModel() {
    return &topicListModel_;
}


SpeechModelState SpeechModel::state()
{
    lock_guard<recursive_mutex> lock(mutex_);
    return state_;
}


QVariant SpeechModel::remainSec()
{
    lock_guard<recursive_mutex> lock(mutex_);
    return QVariant::fromValue(timer_->remainSec());
}


void SpeechModel::start()
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(SpeechModelState::IDLE != state_ && SpeechModelState::TIMESUP != state_ ) {
        return;
    }

    timer_->stop();
    if(SpeechModelState::IDLE == state_) {
        // 初回実行ならトピックを更新
        DrawTopics();
        // 選択タイムに突入
        GoToState(SpeechModelState::SELECTING);
        timer_->start(kSelectionDurationSec);
    } else {
        // リトライならトピックそのままでスピーチタイムに突入
        GoToState(SpeechModelState::SPEAKING);
        timer_->start(kSpeechDurationSec);
    }
}


void SpeechModel::stop()
{
    lock_guard<recursive_mutex> lock(mutex_);
    if(SpeechModelState::IDLE == state_ && SpeechModelState::TIMESUP == state_ ) {
        qDebug() << "ignored";
        return;
    }

    GoToState(SpeechModelState::IDLE);
    timer_->stop();
}

void SpeechModel::next()
{
    stop();
    start();
}


void SpeechModel::TimerRemainSecChanged()
{
    emit remainSecChanged();
}


void SpeechModel::TimerElapsed()
{
    lock_guard<recursive_mutex> lock(mutex_);
    switch(state_) {
    case SpeechModelState::SELECTING:
        GoToState(SpeechModelState::SPEAKING);
        timer_->start(kSpeechDurationSec);
        break;
    case SpeechModelState::SPEAKING:
        GoToState(SpeechModelState::TIMESUP);
        break;
    case SpeechModelState::IDLE:
    default:
        timer_->stop();
        break;
    }
}


void SpeechModel::GoToState(const SpeechModelState& nextState)
{
    if(nextState == state_) {
        return;
    }
    qDebug() << "state" << state_ << " -> " << nextState;
    state_ = nextState;
    emit stateChanged();
}

void SpeechModel::DrawTopics()
{
    array<string, 5> tps;
    drawer_->DrawTopics(tps);
    topicListModel_.addTopics(tps);
}


} // namespace
