module Jekyll
  # Override jekyll-github-metadata plugin
  module GitHubMetadata
    module RepositoryFix
      # Allow to override site.github.source.branch with envvar JEKYLL_BUILD_BRANCH
      # Allow to override site.github.source.path with envvar JEKYLL_BASE_PATH

      def source
        {
          "branch" => ENV["JEKYLL_BUILD_BRANCH"] ||  super["branch"],
          "path" => ENV["JEKYLL_BASE_PATH"] || super["path"],
        }
      end
    end

    class Repository
      prepend RepositoryFix
    end
  end
end
