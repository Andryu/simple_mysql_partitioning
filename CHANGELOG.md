# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-01-31

### Added

- Rails 8.0サポートを追加
  - Ruby 3.2および3.3でRails 8.0のテストに対応
  - `gemfiles/Gemfile.rails-8.0`を追加
  - CIテストマトリックスにRails 8.0を追加
- Rails 8.0は Ruby 3.2以上が必要（CI設定で適切に除外）

### Changed

- `activerecord`の依存関係を`< 8.0`から`< 9.0`に更新
- `activesupport`の依存関係を`< 8.0`から`< 9.0`に更新

### テスト済み構成

- Ruby 3.0: Rails 6.1, 7.0, 7.1
- Ruby 3.1: Rails 6.1, 7.0, 7.1, 7.2
- Ruby 3.2: Rails 6.1, 7.0, 7.1, 7.2, **8.0**
- Ruby 3.3: Rails 6.1, 7.0, 7.1, 7.2, **8.0**

### 注意事項

- Rails 6.1〜7.2との完全な後方互換性を維持
- 既存ユーザーへの破壊的変更なし

---

## [2.0.0] - 2026-01-21

### ⚠️ BREAKING CHANGES

This is a major version upgrade that drops support for end-of-life (EOL) versions of Ruby, Rails, and MySQL. All users must upgrade their environments to supported versions.

#### Minimum Version Requirements

- **Ruby**: 2.3.7+ → **3.0.0+** (Ruby 2.x is no longer supported)
- **Rails/ActiveRecord**: 4.2.1+ → **6.1.0+** (Rails 4.x, 5.x, 6.0.x are no longer supported)
- **MySQL**: 5.7 → **8.0+** (MySQL 5.7 reached EOL in October 2023)

### Added

- Support for Ruby 3.0, 3.1, 3.2, and 3.3
- Support for Rails 6.1, 7.0, 7.1, and 7.2
- GitHub Actions CI/CD pipeline with matrix testing
- Gemfiles for Rails 6.1, 7.0, 7.1, and 7.2
- Comprehensive documentation in CLAUDE.md
- Updated Docker development environment (Ruby 3.3, MySQL 8.0)

### Changed

- Minimum Ruby version raised from 2.3.7 to 3.0.0
- Minimum ActiveRecord version raised from 4.2.1 to 6.1.0
- MySQL requirement updated from 5.7 to 8.0
- Updated development dependencies:
  - `rake`: `>= 10.0` → `~> 13.0`
  - `rspec`: `>= 3.0` → `~> 3.13`
  - `mysql2`: `>= 0.5.0` → `~> 0.5.6`
- Migrated CI from Travis CI to GitHub Actions
- Updated README with new compatibility information

### Removed

- Support for Ruby 2.x (EOL)
- Support for Rails 4.x, 5.x, and 6.0.x (EOL)
- Support for MySQL 5.7 (EOL)
- `activerecord-compatible_legacy_migration` dependency (no longer needed)
- Travis CI configuration

### Migration Guide

#### For Ruby 2.x Users

Ruby 2.x reached end-of-life and is no longer supported. You must upgrade to Ruby 3.0 or higher:

```bash
# Using rbenv
rbenv install 3.3.0
rbenv global 3.3.0

# Using rvm
rvm install 3.3.0
rvm use 3.3.0 --default
```

**Important Ruby 3.x Changes:**
- Keyword arguments are now separated from positional arguments
- Some methods deprecated in Ruby 2.x have been removed
- Hash implicit conversions are stricter

#### For Rails 4.x/5.x/6.0.x Users

Upgrade to Rails 6.1 or higher. Follow the official Rails upgrade guides:
- [Upgrading to Rails 6.1](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-0-to-rails-6-1)
- [Upgrading to Rails 7.0](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-6-1-to-rails-7-0)

#### For MySQL 5.7 Users

MySQL 5.7 reached EOL in October 2023. Upgrade to MySQL 8.0:

```bash
# Docker users
docker pull mysql:8.0

# Direct installation varies by platform
# See: https://dev.mysql.com/doc/refman/8.0/en/upgrading.html
```

**MySQL 8.0 Changes:**
- Default authentication plugin changed to `caching_sha2_password`
- Some reserved words added
- Improved partitioning performance

#### Gemfile Updates

Update your Gemfile:

```ruby
# Before
gem 'simple_mysql_partitioning', '~> 1.0'

# After
gem 'simple_mysql_partitioning', '~> 2.0'
```

Then run:

```bash
bundle update simple_mysql_partitioning
```

### Testing Your Application

After upgrading, thoroughly test your application:

```bash
# Run your test suite
bundle exec rspec

# Test partition operations
rails console
> YourModel.partition.exists?('partition_name')
```

### Support

If you encounter issues during migration:
1. Check the [GitHub Issues](https://github.com/Andryu/simple_mysql_partitioning/issues)
2. Review the updated [README](README.md)
3. Consult [CLAUDE.md](CLAUDE.md) for development guidance

---

## [1.0.0] - Previous Releases

### Features
- RANGE COLUMNS partitioning support
- Partition creation, addition, reorganization, and deletion
- ActiveRecord integration
- Support for Ruby 2.3.7+
- Support for Rails 4.2.1+
- Support for MySQL 5.7+

[2.1.0]: https://github.com/Andryu/simple_mysql_partitioning/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/Andryu/simple_mysql_partitioning/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/Andryu/simple_mysql_partitioning/releases/tag/v1.0.0
