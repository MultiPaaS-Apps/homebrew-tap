# MultiPaaS Homebrew tap

```bash
brew tap multipaas-apps/tap
brew install multipaas-apps/tap/multipaas
```

goreleaser writes `Formula/` on each release of
[MultiPaaS-Apps/cli](https://github.com/MultiPaaS-Apps/cli). Don't edit it by hand.

## While the repositories are private

Two steps need your GitHub access.

1. **Tapping.** The tap is a private git repository, and `brew tap` clones it with git. Give git
   your GitHub credentials over HTTPS with `gh auth login`, then `gh auth setup-git`. Or tap over
   SSH, with a key already loaded in `ssh-agent`:
   `brew tap multipaas-apps/tap git@github.com:MultiPaaS-Apps/homebrew-tap.git`.
2. **Downloading.** The binaries are assets of a private repository's releases, so pass a token
   that can read MultiPaaS-Apps/cli to each install or upgrade:

   ```bash
   HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" brew install multipaas-apps/tap/multipaas
   HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" brew upgrade multipaas
   ```

   `lib/private_release_download.rb` uses that token. It is deleted when the repositories are public.
