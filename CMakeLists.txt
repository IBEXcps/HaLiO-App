project(halio)

cmake_minimum_required(VERSION 3.0)

set(REQUIRED_QT_VERSION "5.7.0")

find_package (ECM 5.10.0 REQUIRED NO_MODULE)
set (CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(ECMAddAppIcon)

if (CMAKE_SYSTEM_NAME STREQUAL "Android")
    find_package(Qt5AndroidExtras ${REQUIRED_QT_VERSION} REQUIRED)
    set(halio_EXTRA_LIBS
        Qt5::AndroidExtras
        Qt5::QuickControls2
        Qt5::Charts
    )
endif()

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS
    Core
    Quick
    Test
    Gui
    Svg
    QuickControls2
    Charts
)

set(halio_SRCS
    main.cpp
)

qt5_add_resources(RESOURCES resources.qrc)

add_executable(halio ${halio_SRCS} ${RESOURCES})
target_link_libraries(halio Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Svg ${halio_EXTRA_LIBS})

install(TARGETS halio ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})