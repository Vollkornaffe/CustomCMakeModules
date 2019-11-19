# idea (hack) from Yves
# https://cmake.org/pipermail/cmake/2015-October/061751.html

# after this function has been called, GLOBAL_BLACKLIST can be used to blacklist targets
function(init_blacklist)

    # in the (unlikely) case that this is also done by some external dependency
    # this variable should be set
    get_property(already_initialized GLOBAL PROPERTY GLOBAL_BLACKLIST_ACTIVE)
    if (already_initialized)
        return()
    endif()

    # Ensure that _<function_name> points to the original version
    # Ensure that __<function_name> points to the original version

    function(add_library)
    endfunction()
    function(_add_library)
    endfunction()

    function(set_target_properties)
    endfunction()
    function(_set_target_properties)
    endfunction()

    function(target_link_directories)
    endfunction()
    function(_target_link_directories)
    endfunction()

    function(target_link_libraries)
    endfunction()
    function(_target_link_libraries)
    endfunction()

    function(add_custom_command)
    endfunction()
    function(_add_custom_command)
    endfunction()

    function(add_dependencies)
    endfunction()
    function(_add_dependencies)
    endfunction()

    function(add_custom_target)
    endfunction()
    function(_add_custom_target)
    endfunction()

    # Define the custom versions

    function(add_library name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            __add_library(${name} ${ARGN})
        endif()
    endfunction()

    function(set_target_properties name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            __set_target_properties(${ARGV})
        endif()
    endfunction()

    function(target_link_directories name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            __target_link_directories(${name} ${ARGN})
        endif()
    endfunction()

    function(target_link_libraries name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            __target_link_libraries(${name} ${ARGN})
        endif()
    endfunction()

    function(add_custom_command type name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT "${type}" STREQUAL "TARGET"
        OR  NOT ${name} IN_LIST blacklist)
            __add_custom_command(TARGET ${name} ${ARGN})
        endif()
    endfunction()

    function(add_custom_target name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            __add_custom_target(${name} ${ARGN})
        endif()
    endfunction()

    function(add_dependencies name)
        get_property(blacklist GLOBAL PROPERTY GLOBAL_BLACKLIST)
        if (NOT ${name} IN_LIST blacklist)
            set(allowed_deps "")
            foreach(dep IN LISTS ARGN)
                if (NOT ${dep} IN_LIST blacklist)
                    list(APPEND allowed_deps ${dep})
                endif()
            endforeach()
            __add_dependencies(${name} ${allowed_deps})
        endif()
    endfunction()

    set_property(GLOBAL PROPERTY GLOBAL_BLACKLIST_ACTIVE ON)

endfunction()

function(remove_blacklist)

    # if init_blacklist wasn't called, __<functionname> isn't doing anything (probably)
    get_property(already_initialized GLOBAL PROPERTY GLOBAL_BLACKLIST_ACTIVE)
    if (already_initialized)
        return()
    endif()

    # Restore the original implementation
    # (and pray that it is still there)

    function(add_library)
        __add_library(${ARGN})
    endfunction()

    function(set_target_properties)
        __set_target_properties(${ARGN})
    endfunction()

    function(target_link_directories)
        __target_link_directories(${ARGN})
    endfunction()

    function(target_link_libraries)
        __target_link_libraries(${ARGN})
    endfunction()

    function(add_custom_command)
        __add_custom_command(${ARGN})
    endfunction()

    function(add_custom_target)
        __add_custom_target(${ARGN})
    endfunction()

    function(add_dependencies)
        __add_dependencies(${ARGN})
    endfunction()

    set_property(GLOBAL PROPERTY GLOBAL_BLACKLIST_ACTIVE OFF)

endfunction()
