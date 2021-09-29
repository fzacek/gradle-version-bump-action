# Gradle Version Bump Action

A simple GitHub Actions to bump the version of Gradle projects.

When triggered, this action will look at the commit message of HEAD~1 and determine if it contains one of `#major` or `#minor` (in that order of precedence).
If true, it will use sed to bump your Gradle build's version by the X.x.x major or x.X.x minor version respectively. All other commits will cause a bump in the x.x.X patch version.

For example, a `#minor` update to version `1.3.9` will result in the version changing to `1.4.0`.
The change will then be committed.

## Sample Usage

```yaml
name: Clojure Version Bump

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - name: Checkout Latest Commit
      uses: actions/checkout@v2

    - name: Bump Version
      id: bump
      uses: fzacek/gradle-version-bump-action@v3
      with:
        github-token: ${{ secrets.github_token }}

    - name: Print Version
      run: "echo 'New Version: ${{steps.bump.outputs.version}}'"
```

## Supported Arguments

* `github-token`: The only required argument. Can either be the default token, as seen above, or a personal access token with write access to the repository
* `git-email`: The email address each commit should be associated with. Defaults to a github provided noreply address
* `git-username`: The GitHub username each commit should be associated with. Defaults to `github-actions[bot]`
* `gradle-path`: The path within your directory the build.gradle you intended to change is located.

## Outputs

* `version` - The after-bump version. Will return the old version if bump was not necessary.
