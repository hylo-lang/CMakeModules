include_guard(GLOBAL)

#  set_file_glob(<variable>
#       [<globbing-expressions>...])
#
# Generates a list of files (but not directories) that match the
# ``<globbing-expressions>`` and stores it into the ``<variable>``,
# following symlinks.
#
# This command will be re-run at build time; if the result changes, CMake will regenerate
# the build system.
function(set_file_glob variable)
  file(GLOB "${variable}"
    FOLLOW_SYMLINKS
    LIST_DIRECTORIES false
    CONFIGURE_DEPENDS ${ARGN})
  set("${variable}" "${${variable}}" PARENT_SCOPE)
endfunction()

#  set_recursive_file_glob(<variable>
#       [<globbing-expressions>...])
#
# Generates a list of files (but not directories) that match the
# ``<globbing-expressions>`` recursively, per file(GLOB_RECURSE), and
# stores it into the ``<variable>``, following symlinks.
#
# This command will be re-run at build time; if the result changes,
# CMake will regenerate the build system.
function(set_recursive_file_glob variable)
  file(GLOB_RECURSE "${variable}"
    FOLLOW_SYMLINKS
    LIST_DIRECTORIES false
    CONFIGURE_DEPENDS ${ARGN})
  set("${variable}" "${${variable}}" PARENT_SCOPE)
endfunction()
