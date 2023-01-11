# Building main application here

set(COMMON_SOURCES
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
    ${CMAKE_CURRENT_LIST_DIR}/utils/utils.cpp
    ${CMAKE_CURRENT_LIST_DIR}/utils/types_support.cpp
    ${CMAKE_CURRENT_LIST_DIR}/utils/platform_support.cpp
    ${CMAKE_CURRENT_LIST_DIR}/command/command.cpp
    ${CMAKE_CURRENT_LIST_DIR}/special_commands/special_commands.cpp
    ${CMAKE_CURRENT_LIST_DIR}/special_commands/filters.cpp
)
set(COMMON_INCLUDES
    ${CMAKE_CURRENT_LIST_DIR}/utils
    ${CMAKE_CURRENT_LIST_DIR}/device
    ${CMAKE_CURRENT_LIST_DIR}/command
    ${CMAKE_CURRENT_LIST_DIR}/special_commands
    ${DEVICE_CONTROL_PATH}/api
)

add_executable(xvf_hostapp_rpi)

target_sources(xvf_hostapp_rpi
    PRIVATE
        ${COMMON_SOURCES}
)
target_include_directories(xvf_hostapp_rpi
    PUBLIC
        ${COMMON_INCLUDES}
)
target_link_libraries(xvf_hostapp_rpi
    PUBLIC 
        dl
)
target_link_options(xvf_hostapp_rpi
    PRIVATE
        -rdynamic
)

# If using clang disable c-linkage warning
if(HAVE_C_LINKAGE_WARNING)
    target_compile_options(xvf_hostapp_rpi PRIVATE -Wno-return-type-c-linkage)
endif()
