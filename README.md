# Homebrew tap for alt

This repository hosts the Homebrew / Linuxbrew tap for
[`alt`](https://github.com/dotboris/alt).

If you're looking for the offical `alt` repository, please head to
<https://github.com/dotboris/alt>.

## Usage

```sh
brew tap dotboris/alt
brew install alt-bin
```

If you'd like to install from source (this takes a while) you can do:

```sh
brew install alt
```

## Development

### Testing in an isolated environment

You can setup an isolated test environment using `docker-compose`.

1.  Start the test environment

    ```sh
    docker-compose up -d
    ```

1.  Start a shell in the test environment

    ```sh
    docker-compose run linuxbrew /bin/bash
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
docker-compose down
```

Once that's done, you can just repeat the steps above.
