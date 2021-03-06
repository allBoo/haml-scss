from setuptools import setup, find_packages
import os

setup(
    author='Dan LaMotte',
    author_email='lamotte85@gmail.com',
    name='haml-scss',
    version='0.8.1',
    description='haml and scss for python',
    long_description=open(os.path.join(os.path.dirname(__file__), 'README.markdown')).read(),
    url='git@github.com:allBoo/haml-scss.git',
    keywords='haml sass scss django integration template',
    install_requires=[
        'pyScss>=1.0.8',
        'regex',
    ],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False
)
