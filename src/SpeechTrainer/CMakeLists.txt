cmake_minimum_required(VERSION 3.16)

project(SpeechTrainer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)

set(RESOURCE ${CMAKE_SOURCE_DIR}/speechtrainer.qrc)
qt_add_resources(RESOURCE_ADDED ${RESOURCE})

qt_add_executable(appSpeechTrainer
    main.cpp
    mainmodel.h mainmodel.cpp
    countdowntimer.h countdowntimer.cpp
    topicdrawer.h topicdrawer.cpp
    topiclistmodel.h topiclistmodel.cpp
    topicitemmodel.h topicitemmodel.cpp
    ${RESOURCE_ADDED}
)

qt_add_qml_module(appSpeechTrainer
    URI SpeechTrainer
    VERSION 1.0
    QML_FILES main.qml
)

set_target_properties(appSpeechTrainer PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSpeechTrainer
    PRIVATE Qt6::Quick)

install(TARGETS appSpeechTrainer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
