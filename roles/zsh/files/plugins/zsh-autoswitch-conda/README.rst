Autoswitch Python Conda
============================

|TravisCI| |Release| |GPLv3|

*zsh-autoswitch-conda* is a simple ZSH plugin (which is modified from `zsh-autoswitch-virtualenv <https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv/>`__)
that switches conda environments automatically as you move between directories.

* `How it Works`_
* `More Details`_
* Installing_
* Setup_
* Commands_
* Options_
* `Security Warnings`_
* `Running Tests (not available now)`_


How it Works
------------

Simply call the ``mkcenv`` command in the directory you wish to setup a
conda environment. A conda environment specific to that folder will
now activate every time you enter it.

See the *Commands* section below for more detail.

More Details
------------

Moving out of the directory will automatically deactivate the conda
environment. However you can also switch to a default python conda
environment instead by setting the ``AUTOSWITCH_DEFAULT_CONDAENV`` environment
variable.

Internally this plugin simply works by creating a file named ``.cenv``
which contains the name of the conda environment created (which is the
same name as the current directory but can be edited if needed). There
is then a precommand hook that looks for a ``.cenv`` file and switches
to the name specified if one is found.

**NOTE**: you may want to add ``.cenv`` to your ``.gitignore`` in git
projects (or equivalent file for the Version Control you are using).

Installing
----------

Add one of the following lines to your ``.zshrc`` file depending on the
package manager you are using:

ZPlug_

::

    zplug "bckim92/zsh-autoswitch-conda"

Antigen_

::

    antigen bundle "bckim92/zsh-autoswitch-conda"

Zgen_

::

    zgen load "bckim92/zsh-autoswitch-conda"

Setup
-----

``conda`` must be installed for this plugin to work correctly.
You can find installation instructions from `official conda user guide <https://conda.io/docs/user-guide/install/index.html#installation>`__.
For example, in linux 64-bit environment, you can install Miniconda-python3 as follows:

::

    # https://conda.io/miniconda.html
    set -e
    MINICONDA_VERSION="4.5.4"

    # https://repo.continuum.io/miniconda/
    TMP_DIR="/tmp/$USER/miniconda/"; mkdir -p $TMP_DIR && cd ${TMP_DIR}
    wget -nc "https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"

    # will install at $HOME/.miniconda3 (see zsh config for PATH)
    MINICONDA_PREFIX="$HOME/.miniconda3/"
    bash "Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" -b -p ${MINICONDA_PREFIX}

    $MINICONDA_PREFIX/bin/python --version

You need to add environment variables for conda to your ``.zshenv`` file as part of your
setup. For example,

::

    . YOUR_CONDA_PATH/etc/profile.d/conda.sh

**IMPORTANT:** Make sure this is put *before* your package manager loading code (i.e. the
line of code discussed in the section that follows).

Commands
--------

mkcenv
''''''

Setup a new project with conda envirionment autoswitching using the ``mkcenv``
helper command.

::

    $ cd my-python-project
    $ mkcenv
    Solving environment: done
    ## Package Plan ##
    environment location: /home/bckim92/.miniconda3/envs/my-python-project
    added / updated specs:
      - python=3.5
    The following NEW packages will be INSTALLED:
        ca-certificates: 2018.03.07-0
        certifi:         2018.4.16-py35_0
        libedit:         3.1.20170329-h6b74fdf_2
        libffi:          3.2.1-hd88cf55_4
        libgcc-ng:       7.2.0-hdf63c60_3
        libstdcxx-ng:    7.2.0-hdf63c60_3
        ncurses:         6.1-hf484d3e_0
        openssl:         1.0.2o-h20670df_0
        pip:             10.0.1-py35_0
        python:          3.5.5-hc3d631a_4
        readline:        7.0-ha6073c6_4
        setuptools:      39.2.0-py35_0
        sqlite:          3.24.0-h84994c4_0
        tk:              8.6.7-hc745277_3
        wheel:           0.31.1-py35_0
        xz:              5.2.4-h14c3975_4
        zlib:            1.2.11-ha838bed_2
    Proceed ([y]/n)?

Optionally, you can specify the python binary to use for this conda environment

::

    $ mkcenv python=3.5

In fact, ``mkcenv`` supports any parameters that can be passed to ``conda create``

``mkcenv`` will create a conda environment with the same name as the
current directory, suggest installing ``requirements.txt`` if available
and create the relevant ``.cenv`` file for you.

Next time you switch to that folder, you'll see the following message

::

    $ cd my-python-project
    Switching conda environment: my-python-project  [Python 3.5.5 :: Anaconda, Inc.]
    $

If you have set the ``AUTOSWITCH_DEFAULT_CONDAENV`` environment variable,
exiting that directory will switch back to the value set.

::

    $ cd ..
    Switching conda environment: mydefaultenv  [Python 3.5.5 :: Anaconda, Inc.]
    $

Otherwise, ``conda deactivate`` will simply be called on the conda to
switch back to the global python environment.

Autoswitching is smart enough to detect that you have traversed to a
project subdirectory. So your conda environment will not be deactivated if you
enter a subdirectory.

::

    $ cd my-python-project
    Switching conda environment: my-python-project  [Python 3.4.3+]
    $ cd src
    $ # Notice how this has not deactivated the project conda environment
    $ cd ../..
    Switching conda environment: mydefaultenv  [Python 3.4.3+]
    $ # exited the project parent folder, so the conda environment is now deactivated

rmcenv
''''''

You can remove the conda environment for a directory you are currently
in using the ``rmcenv`` helper function:

::

    $ cd my-python-project
    $ rmcenv
    Switching conda environment: mydefaultenv  [Python 2.7.12]
    Removing myproject...

This will delete the conda environment in ``.cenv`` and remove the
``.cenv`` file itself. The ``rmcenv`` command will fail if there is no
``.cenv`` file in the current directory:

::

    $ cd my-non-python-project
    $ rmcenv
    No .cenv file in the current directory!

Options
-------

**Setting a default conda environment**

If you want to set a default conda environment then you can also
export ``AUTOSWITCH_DEFAULT_CONDAENV`` in your ``.zshrc`` file.

::

    export AUTOSWITCH_DEFAULT_CONDAENV="mydefaultenv"
    antigen bundle bckim92/zsh-autoswitch-conda

**Set verbosity when changing environments**

You can prevent verbose messages from being displayed when moving
between directories. You can do this by setting ``AUTOSWITCH_SILENT`` to
a non-empty value.

Security Warnings
-----------------

zsh-autoswitch-conda will warn you and refuse to activate a conda
envionrment automatically in the following situations:

-  You are not the owner of the ``.cenv`` file found in a directory.
-  The ``.cenv`` file has weak permissions. I.e. it is readable or
   writable by other users on the system.

In both cases, the warnings should explain how to fix the problem.

These are security measures that prevents other, potentially malicious
users, from switching you to a conda environment you did not want to
switch to.

Running Tests (not available now)
---------------------------------

Install `zunit <https://zunit.xyz/>`__. Run ``zunit`` in the root
directory of the repo.

::

    $ zunit
    Launching ZUnit
    ZUnit: 0.8.2
    ZSH:   zsh 5.3.1 (x86_64-suse-linux-gnu)

    ✔ _check_venv_path - returns nothing if not found
    ✔ _check_venv_path - finds .venv in parent directories
    ✔ _check_venv_path - returns nothing with root path
    ✔ check_venv - Security warning for weak permissions

NOTE: It is required that you use a minimum zunit version of 0.8.2


.. _Zplug: https://github.com/zplug/zplug

.. _Antigen: https://github.com/zsh-users/antigen

.. _ZGen: https://github.com/tarjoilija/zgen

.. |TravisCI| image:: https://travis-ci.org/MichaelAquilina/zsh-autoswitch-virtualenv.svg?branch=master
   :target: https://travis-ci.org/MichaelAquilina/zsh-autoswitch-virtualenv

.. |Release| image:: https://badge.fury.io/gh/MichaelAquilina%2Fzsh-autoswitch-virtualenv.svg
    :target: https://badge.fury.io/gh/MichaelAquilina%2Fzsh-autoswitch-virtualenv

.. |GPLv3| image:: https://img.shields.io/badge/License-GPL%20v3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

TODO
----

-  Modify test code
-  Modify TravisCI and Release image
