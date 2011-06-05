from django.conf.urls.defaults import *

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    (r'^admin/', include(admin.site.urls)),
)

urlpatterns += patterns('django.views.generic.simple',
    ('^$', 'direct_to_template', {
        'template': 'index.haml',
    }),
    ('^mixed/$', 'direct_to_template', {
        'template': 'subbase.haml',
    }),
)
