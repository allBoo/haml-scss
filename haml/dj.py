from django.template.loaders.filesystem import Loader as DjFSLoader
from django.template.loaders.app_directories import Loader as DjAppLoader

from haml.compiler import Compiler

from io import StringIO

class FSLoader(DjFSLoader):
    is_usable = True

    def get_contents(self, origin):
        if not origin.name.endswith('.haml'):
            return super(FSLoader, self).get_contents(origin)

        out = StringIO()
        # TODO nasty open(fn) workaround .decode(settings.FILE_CHARSET) issue.
        # regex in compiler module stops matching... unsure why
        Compiler(open(origin.name), out).compile()
        return out.getvalue()
    get_contents.is_usable = True


class AppLoader(FSLoader, DjAppLoader):
    pass
