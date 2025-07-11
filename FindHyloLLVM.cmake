# Distributed under the Apache License, Version 2.0, with Runtime Library
# Exception.  See accompanying file LICENSE for details.

#[=======================================================================[.rst:
FindHyloLLVM
---------------

Finds the LLVM library used by Hylo and Swifty-LLVM.

Targets and Variables
^^^^^^^^^^^^^^^^^^^^^

This module provides the same targets and variables (cache or
otherwise) as your LLVM installation's LLVMConfig.cmake does.

#]=======================================================================]
include_guard(GLOBAL)

# Boilerplate from https://llvm.org/docs/CMake.html#embedding-llvm-in-your-project
find_package(LLVM 20.1 REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

# Work around LLVM link options incompatible with the swift linker.
# See https://github.com/llvm/llvm-project/pull/65634
if(TARGET LLVMSupport)
  get_target_property(interface_libs LLVMSupport INTERFACE_LINK_LIBRARIES)
  if(-delayload:shell32.dll IN_LIST interface_libs)
    # the delayimp argument shows up as -ldelayimp.lib in shared library builds for
    # some reason.
    list(REMOVE_ITEM interface_libs
      delayimp -ldelayimp.lib  -delayload:shell32.dll -delayload:ole32.dll)
    list(APPEND interface_libs
      $<$<NOT:$<LINK_LANGUAGE:Swift>>:delayimp -delayload:shell32.dll -delayload:ole32.dll>)
    set_target_properties(LLVMSupport
      PROPERTIES INTERFACE_LINK_LIBRARIES "${interface_libs}")
  endif()
endif()
