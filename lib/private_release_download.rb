# typed: strict
# frozen_string_literal: true

require "download_strategy"

# Downloads a release asset of a private GitHub repository, authenticated with
# HOMEBREW_GITHUB_API_TOKEN.
# Delete this file, and the two lines in the cli repo's .goreleaser.yaml that use it, when the
# MultiPaaS-Apps/cli repository is public.
class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  RELEASE_ASSET = %r{\Ahttps://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/]+)\z}

  def initialize(url, name, version, **meta)
    @owner, @repo, @tag, @filename = RELEASE_ASSET.match(url)&.captures
    raise CurlDownloadStrategyError, "Not a GitHub release asset URL: #{url}" if @filename.nil?

    token = ENV.fetch("HOMEBREW_GITHUB_API_TOKEN") do
      raise CurlDownloadStrategyError, "Set HOMEBREW_GITHUB_API_TOKEN to install from this private tap, " \
                                       'e.g. HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"'
    end
    meta[:headers] = [*meta[:headers], "Accept: application/octet-stream", "Authorization: Bearer #{token}"]
    super("https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}", name, version, **meta)
  end

  private

  def asset_id
    asset = GitHub.get_release(@owner, @repo, @tag)["assets"].find { |candidate| candidate["name"] == @filename }
    raise CurlDownloadStrategyError, "#{@filename} is not an asset of #{@owner}/#{@repo} #{@tag}" if asset.nil?

    asset["id"]
  end
end
