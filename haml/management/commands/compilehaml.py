from django.conf import settings
from django.core.management.base import CommandError, NoArgsCommand

from haml.compiler import Compiler

import errno
import os

# TODO enhance to work with app_directories.Loader?

class Command(NoArgsCommand):
    help = 'Compile all .haml files in TEMPLATE_DIRS to HAML_COMPILED'

    def handle_noargs(self, **options):
        try:
            haml_path = settings.HAML_COMPILED
        except AttributeError:
            raise CommandError(
                'You must specify a HAML_COMPILED path in settings'
            )

        for template_dir in settings.TEMPLATE_DIRS:
            # trick to add proper trailing slash if necessary
            l = len(os.path.join(template_dir + '/', ''))

            for dirpath, dirnames, filenames in os.walk(template_dir):
                for fn in filenames:
                    if fn.lower().endswith('.haml'):
                        print os.path.join(dirpath[l:], fn)

                        newfn = os.path.join(haml_path, dirpath[l:], fn)
                        target_dir = os.path.dirname(newfn)
                        leftover = []
                        while True:
                            try:
                                os.mkdir(target_dir)
                            except OSError as e:
                                if e.errno == errno.ENOENT:
                                    leftover.insert(0, target_dir)
                                    target_dir = os.path.dirname(target_dir)

                                elif e.errno == errno.EEXIST:
                                    break

                                else:
                                    raise
                            else:
                                break

                        for d in leftover:
                            os.mkdir(d)

                        Compiler(
                            open(os.path.join(dirpath, fn)),
                            open(newfn, 'w')
                        ).compile()
