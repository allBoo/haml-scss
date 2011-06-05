import os

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))

TEMPLATE_LOADERS = (
    'haml.dj.FSLoader',
    'haml.dj.AppLoader',
    #'django.template.loaders.filesystem.Loader', XXX no longer necessary
    #'django.template.loaders.app_directories.Loader', XXX no longer necessary
)
TEMPLATE_DIRS = (
    os.path.join(PROJECT_DIR, 'templates'),
)

# everything below is unimportant

DEBUG = True
TEMPLATE_DEBUG = DEBUG

MANAGERS = ADMINS = ()

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': 'example.db',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
    }
}

TIME_ZONE = 'America/Chicago'
LANGUAGE_CODE = 'en-us'
SITE_ID = 1
USE_I18N = True
USE_L10N = True

MEDIA_ROOT = ''
MEDIA_URL = ''
ADMIN_MEDIA_PREFIX = '/media/'
SECRET_KEY = '3b7gb3rwf)hpw2&rs06!xdy2^68ak2yct=ny*ofsf4au2^q$64'

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
)

ROOT_URLCONF = 'example.urls'

INSTALLED_APPS = (
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.messages',
    'django.contrib.admin',
)
