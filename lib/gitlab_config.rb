require 'yaml'

class GitlabConfig
  attr_reader :config

  def initialize
    @config = YAML.load_file(File.join(ROOT_PATH, 'config.yml'))
  end

  def repos_group
    @config['repos_group'] ||= 'git'
  end

  def repos_owner
    @config['repos_owner'] ||= @config['user'] || 'git'
  end

  def repos_path
    @config['repos_path'] ||= "/home/git/repositories"
  end

  def auth_file
    @config['auth_file'] ||= "/home/git/.ssh/authorized_keys"
  end

  def gitlab_url
    @config['gitlab_url'] ||= "http://localhost/"
  end

  def http_settings
    @config['http_settings'] ||= {}
  end

  def log_file
    @config['log_file'] ||= File.join(ROOT_PATH, 'gitlab-shell.log')
  end

  def log_level
    @config['log_level'] ||= 'INFO'
  end

  def audit_usernames
    @config['audit_usernames'] ||= false
  end

end
