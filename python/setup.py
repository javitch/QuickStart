from distutils.core import setup 

setup(name              = 'py-gridvid',
      version           = '0.0.1',
      description       = open('../VERSION').read(),
      author            = 'Christopher J. Hanks',
      author_email      = 'cjhanks@cpusage.com',
      maintainer        = 'GridVid',
      maintainer_email  = 'info@gridvid.me',
      url               = 'https://gridvid.me',
      packages          = ['gridvid'],
      package_dir       = {'gridvid' : 'lib'},
      license           = 'GPLv3'
      )
