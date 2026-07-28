# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-07-28

### Fixed
- Relaxed `prism` dependency from `~> 0.19` to `~> 1.2` to resolve a version conflict with `ruby-lsp ~> 0.26`, which requires `prism >= 1.2, < 2.0`

## [0.2.0]

### Added
- Consider association syntax when navigating to factory definitions

## [0.1.0] - 2025-01-XX

### Added
- Initial release
- Go to Definition support for FactoryBot factories
- Support for factory aliases (`:aliases` parameter)
- Recursive indexing of `spec/factories/**/*.rb`
- Support for all common FactoryBot methods: `create`, `build`, `build_list`, `create_list`, `attributes_for`
- Support for both symbol and string factory names
