import os
import ycm_core

flags = [
    '-Wall',
    '-Wextra',
    '-x',
    'c',
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def FlagsForFile( filename, **kwargs ):
  return {
    'flags': flags,
    'do_cache': True
  }

