from django.conf import settings
from django.core.management.base import NoArgsCommand

from scss import Scss

import os

class Command(NoArgsCommand):
    help = 'Compile all .scss files in STATIC_ROOT after collectstatic'

    def handle_noargs(self, **options):
        for dirpath, dirnames, filenames in os.walk(settings.STATIC_ROOT):
            for fn in filenames:
                if fn.lower().endswith('.scss'):
                    print os.path.join(dirpath, fn)
                    newfn = fn[:-5] + '.css'
                    open(os.path.join(dirpath, newfn), 'w').write(
                        Scss().compile(
                            open(os.path.join(dirpath, fn)).read()
                        )
                    )
