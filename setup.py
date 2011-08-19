from setuptools import setup, find_packages
import os

setup(
    author='Dan LaMotte',
    author_email='lamotte85@gmail.com',
    name='haml-scss',
    version='0.5.1',
    description='haml for python (scss coming soon)',
    long_description=open(os.path.join(os.path.dirname(__file__), 'README.markdown')).read(),
    url='https://bitbucket.org/dlamotte/haml-scss',
    keywords='haml sass scss django template',
    install_requires=[
        'pyScss>=1.0.8',
    ],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False
)
