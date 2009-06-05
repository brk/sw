# Copyright (c) 2009 Ben Karel
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# TODO: change handling of user homedir? dunno yet if that would be good or bad.

def find_cd2(path, old, new):
  """
>>> find_cd2('/a/path', 'a', 'b')
'/b/path'
>>> find_cd2('/a/path', 'path', 'b')
'/a/b'
>>> find_cd2('/a/path', 'pa', 'b')
'/a/b'
>>> find_cd2('/another/a/path', 'an', 'b')
'/b/a/path'
>>> find_cd2('/another/a/path', 'a', 'b')
'/another/b/path'
"""
  pc = splitpath(path) # path components
  if old in pc:
    nc = [] # new path components
    for x in pc:
      if x == old:
        nc.append(new)
      else:
        nc.append(x)
    return pathjoin(nc)
  else:
    # No path component matches exactly;
    # look for first path component that
    # starts with old and replace only it.
    nc = []
    while len(pc) > 0:
      x = pc.pop(0)
      if x.startswith(old):
        # TODO: search sibs of pathjoin(nc)
        # for paths starting with new.
        # Thus:
        # > pwd
        # /www/development/deep/project/directories/
        # > cd dev prod
        # /www/production/deep/project/directories/
        nc.append(new)
        break
      else:
        nc.append(x)
    nc.extend(pc)
    return pathjoin(nc)
  pass

def splitpath(path):
  """
>>> splitpath('/a/path')
['', 'a', 'path']
>>> splitpath('a/path')
['a', 'path']
>>> splitpath('a/')
['a']
>>> splitpath('a')
['a']
>>> splitpath('/')
['']
>>> splitpath('')
['.']
"""
  if path == '':
    return ['.']

  import os.path
  head = path
  pc = []
  while head != '' and head != os.sep:
    head, tail = os.path.split(head)
    pc.insert(0, tail)
  if head == os.sep:
    pc.insert(0, '')
  if pc[-1] == '' and len(pc) > 1:
    pc.pop()

  return pc

def pathjoin(pc):
  """
>>> pathjoin(["", "a", "path"])
'/a/path'
>>> pathjoin(["a", "path"])
'a/path'
"""
  import os.path
  if pc[0] == '':
    pc[0] = os.sep
  return os.path.join(*pc)

if __name__ == '__main__':
  import sys
  if len(sys.argv) > 1:
    if sys.argv[1] == 'test':
      import doctest
      doctest.testmod()
    else:
      print find_cd2(*sys.argv[1:4])
