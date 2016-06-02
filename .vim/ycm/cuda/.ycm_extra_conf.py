import os
import ycm_core

flags = [
    '-Wall',
    '-Wextra',
    '-Wno-long-long',
    '-Wno-variadic-macros',
    # '-Wno-overloaded-shift-op-parentheses',
    '-fexceptions',
    # '-std=c++11',
    '-x',
    'cuda',
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm', ]

def FlagsForFile( filename, **kwargs ):
  return {
    'flags': flags,
    'do_cache': True
  }

