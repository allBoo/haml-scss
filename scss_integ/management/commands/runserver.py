from django.conf import settings
from django.core.management.commands.runserver import \
    Command as RunserverCommand
from django.core.handlers.wsgi import WSGIHandler
from django.core.servers.basehttp import AdminMediaHandler
from django.contrib.staticfiles.views import serve
from django.http import Http404

import os

from scss import Scss

class ScssMediaHandler(AdminMediaHandler):
    def __init__(self, *args, **kwargs):
        super(ScssMediaHandler, self).__init__(*args, **kwargs)

    def _scss_should_handle(self, path):
        return path.startswith(settings.STATIC_URL) and path.endswith('.css')

    def serve(self, request):
        path = request.path[len(settings.STATIC_URL):]
        try:
            resp = serve(request, path)
        except Http404:
            resp = serve(request, path[:-4] + '.scss')
            resp.content = Scss().compile(resp.content)
            resp['Content-Length'] = len(resp.content)
        return resp

    def get_response(self, request):
        from django.http import Http404

        if self._scss_should_handle(request.path):
            try:
                return self.serve(request)
            except Http404, e:
                if settings.DEBUG:
                    from django.views import debug
                    return debug.technical_404_response(request, e)

        return super(ScssMediaHandler, self).get_response(request)

    def __call__(self, environ, start_response):
        if self._scss_should_handle(environ['PATH_INFO']):
            # skip parent call chain
            return WSGIHandler.__call__(self, environ, start_response)
        return super(ScssMediaHandler, self).__call__(environ, start_response)

class Command(RunserverCommand):
    def get_handler(self, *args, **options):
        handler = super(Command, self).get_handler(*args, **options)
        return ScssMediaHandler(handler, options.get('admin_media_path', ''))
