cmake_minimum_required(VERSION 3.21)

project(cicretro
    VERSION 0.1
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
)

qt_standard_project_setup()

qt_add_executable(cicretro
    cicretro.cpp
)

qt_add_resources(cicretro "qml_resources"
    PREFIX "/"
    FILES
        Main.qml
        CicShell.qml
        CicVisual.qml
)

target_link_libraries(cicretro PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)