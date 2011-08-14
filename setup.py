from setuptools import setup
import os

setup(
    name='haml-scss',
    version='0.5.1',
    packages=['haml', ],
    author='Dan LaMotte',
    author_email='lamotte85@gmail.com',
    description='haml for python (scss coming soon)',
    long_description=open(os.path.join(os.path.dirname(__file__), 'README.markdown')).read(),
    keywords='haml sass scss django template',
    url='https://bitbucket.org/dlamotte/haml-scss',
)
