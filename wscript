APPNAME = 'blockhash'
VERSION = '0.2'

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.add_option('--debug', dest='debug', action='store_true', default=False, help='Set to debug to enable debug symbols')

def configure(conf):
    conf.load('compiler_c')

    conf.check_cc(lib='m')
    conf.check_cfg(package='MagickWand', args=['--cflags', '--libs'])

def build(bld):
    bld.program(source='blockhash.c',
                features='c cprogram',
                target='blockhash',
                use=['MAGICKWAND', 'M']
               )
