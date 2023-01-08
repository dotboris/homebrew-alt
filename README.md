# Homebrew tap for alt

[![Build Status](https://travis-ci.com/dotboris/homebrew-alt.svg?branch=master)](https://travis-ci.com/dotboris/homebrew-alt)

This repository hosts the Homebrew / Linuxbrew tap for
[`alt`](https://github.com/dotboris/alt).

If you're looking for the offical `alt` repository, please head to
<https://github.com/dotboris/alt>.

## Usage

```sh
brew tap dotboris/alt
brew install alt
```

## Development

### Environment setup

You can setup an isolated test environment using `docker-compose`.

1.  Start the test environment

    ```sh
    docker-compose up -d --remove-orphans
    ```

1.  Start a shell in the test environment

    ```sh
    docker-compose run brew /bin/bash
    ```

1.  Configure linuxbrew

    ```sh
    eval $(brew shellenv)
    ```

This will leave you in a shell with `brew` installed and configured. You can now
do things like `brew install alt`.

If you every need to clean out this environment and start over again, you can
destroy the environment with:

```sh
exit # exit out of the environment
docker-compose down --remove-orphans
```

Once that's done, you can just repeat the steps above.

### Testing install

Once you have a setup environment, the simplest way to test is to run

```sh
brew install alt --build-from-source --verbose --debug
```

### Bumping version

1.  Create a branch
1.  Setup and enter the development environment
1.  `brew bump-formula-pr --write-only --version {version-here} alt`
1.  Exit the development environment
1.  Commit
1.  Create PR
1.  The CI will run tests and build a bottles for you
1.  When you're ready to merge add the `pr-pull` label to the PR. A new CI job
    will start that will merge your changes to `main`. This process also adds
    the bottles references to the formulas.
