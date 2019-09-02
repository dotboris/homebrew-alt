#!/usr/bin/env python3
import subprocess
from glob import glob
from os import path


def sh(*args):
    print("\033[1m>>> {0}\033[0m".format(' '.join(args)))
    return subprocess.run(args, check=True)


def formulas(root):
    files = glob(path.join(root, 'Formula/*.rb'))
    files = map(path.basename, files)
    res = map(lambda file: path.splitext(file)[0], files)
    return list(res)


def main():
    root = path.dirname(path.dirname(__file__))

    test_subjects = formulas(root)

    sh('brew', 'audit', '--strict', '--online', *test_subjects)

    for subject in test_subjects:
        sh('brew', 'install', '--verbose', subject)
        sh('brew', 'test', subject)
        sh('brew', 'uninstall', subject)


if __name__ == '__main__':
    main()
