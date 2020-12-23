if(NOT ANDROID_PACKAGE_NAME)
  set(ANDROID_PACKAGE_NAME "com.github.stevenlovegrove.pangolin")
endif()

if(NOT ANDROID_DEFERRED_ENTRY_SO)
  set(ANDROID_DEFERRED_ENTRY_SO "libpangolin.so")
endif()

# Configure build environment to automatically generate APK's instead of executables.
if(ANDROID AND NOT TARGET apk)
    # virtual targets which we'll add apks and push actions to.
    add_custom_target( apk )
    add_custom_target( push )
    add_custom_target( run )

    # Reset output directories to be in binary folder (rather than source)
    set(LIBRARY_OUTPUT_PATH_ROOT ${CMAKE_CURRENT_BINARY_DIR})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_PATH_ROOT}/libs/${ANDROID_NDK_ABI_NAME})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_PATH_ROOT}/libs/${ANDROID_NDK_ABI_NAME})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_PATH_ROOT}/bin/${ANDROID_NDK_ABI_NAME})

    # Override add_executable to build android .so instead!
    macro( add_executable prog_name)
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libs/${ANDROID_NDK_ABI_NAME})
        add_library( ${prog_name} SHARED ${ARGN} )

        # Add required link libs for android
        target_link_libraries(${prog_name} log android )

        # Generate ant build system for APK
        # android_update( ${prog_name} )

#        # Target to invoke ant build system for APK
#        set( APK_FILE "${CMAKE_CURRENT_BINARY_DIR}/bin/${prog_name}-debug.apk" )
#        add_custom_command(
#            OUTPUT ${APK_FILE}
#            COMMAND ant debug
#            DEPENDS ${prog_name}
#            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#        )
#
#        # Target to install on device
#        add_custom_target( ${prog_name}-apk
#            DEPENDS ${APK_FILE}
#        )
#        add_dependencies(apk ${prog_name}-apk)
#
#        # Target to install on device
#        add_custom_target( ${prog_name}-push
#            COMMAND adb install -r ${APK_FILE}
#            DEPENDS ${APK_FILE}
#        )
#        add_dependencies(push ${prog_name}-push)
#
#        # install and run on device
#        add_custom_target( ${prog_name}-run
#            COMMAND adb shell am start -n ${ANDROID_PACKAGE_NAME}.${prog_name}/android.app.NativeActivity
#            DEPENDS ${prog_name}-push
#            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#        )
#        add_dependencies(run ${prog_name}-run)
#
#        # Flag to package dependent libs
#        set_property(TARGET ${prog_name} APPEND PROPERTY MAKE_APK 1 )
#
#        # Clear shared library loading header
#        file( WRITE "${CMAKE_CURRENT_BINARY_DIR}/${prog_name}_shared_load.h" "")
    endmacro()

    macro( package_with_target prog_name lib_path )
        # Mark lib_path as dependent of prog_name
        set_property(TARGET ${prog_name} APPEND PROPERTY IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE ${lib_path} )

        # If prog_name is to be packaged, add file copy command to package .so's.
        get_target_property( package_dependent_libs ${prog_name} MAKE_APK )
        if( package_dependent_libs )
            get_filename_component(target_filename ${lib_path} NAME)
            file( APPEND ${depend_file} "load_lib(LIB_PATH \"${target_filename}\" );\n")
            add_custom_command(TARGET ${prog_name} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${lib_path} "${CMAKE_CURRENT_BINARY_DIR}/libs/${ANDROID_NDK_ABI_NAME}/"
            )
        endif()
    endmacro()

    macro( add_to_depend_libs prog_name depend_file lib_name )
        # Recursively Process dependents of lib_name
        get_target_property(TARGET_LIBS ${lib_name} IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE)
        if(NOT TARGET_LIBS)
            get_target_property(TARGET_LIBS ${lib_name} IMPORTED_LINK_INTERFACE_LIBRARIES_NOCONFIG)
        endif()
        if(NOT TARGET_LIBS)
            get_target_property(TARGET_LIBS ${lib_name} IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG)
        endif()

        foreach(SUBLIB ${TARGET_LIBS})
            if(SUBLIB)
                add_to_depend_libs( ${prog_name} ${depend_file} ${SUBLIB} )
            endif()
        endforeach()

        # Check if lib itself is an external shared library
        if("${lib_name}" MATCHES "\\.so$")
            package_with_target( ${prog_name} ${lib_name} )
        endif()

        # Check if lib itself is an internal shared library
        get_target_property(TARGET_LIB ${lib_name} LOCATION)
        if("${TARGET_LIB}" MATCHES "\\.so$")
            package_with_target( ${prog_name} ${TARGET_LIB} )
        endif()
    endmacro()

#    macro( target_link_libraries prog_name)
#        # _target_link_libraries corresponds to original
#        _target_link_libraries( ${prog_name} ${ARGN} )
#
#        # Recursively process dependencies
#        set(depend_file "${CMAKE_CURRENT_BINARY_DIR}/${prog_name}_shared_load.h" )
#        foreach( LIB ${ARGN} )
#            add_to_depend_libs( ${prog_name} ${depend_file} ${LIB} )
#        endforeach()
#    endmacro()

endif()
