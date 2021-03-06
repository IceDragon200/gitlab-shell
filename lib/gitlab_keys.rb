require 'tempfile'

require_relative 'gitlab_config'
require_relative 'gitlab_logger'

class GitlabKeys
  attr_accessor :auth_file, :key

  def initialize
    @command = ARGV.shift
    @key_id = ARGV.shift
    @key = ARGV.shift
    @auth_file = GitlabConfig.new.auth_file
  end

  def exec
    case @command
    when 'add-key' then add_key
    when 'rm-key'  then rm_key
    when 'clear'   then clear
    else
      $logger.warn "Attempt to execute invalid gitlab-keys command #{@command.inspect}."
      puts 'not allowed'
      false
    end
  end

  protected

  def add_key
    $logger.info "Adding key #{@key_id} => #{@key.inspect}"
    auth_line = "command=\"#{ROOT_PATH}/bin/gitlab-shell #{@key_id}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{@key}"
    open(auth_file, 'a') { |file| file.puts(auth_line) }
    true
  end

  def rm_key
    $logger.info "Removing key #{@key_id}"
    Tempfile.open('authorized_keys') do |temp|
      open(auth_file, 'r+') do |current|
        current.each do |line|
          temp.puts(line) unless line.include?("/bin/gitlab-shell #{@key_id}\"")
        end
      end
      temp.close
      FileUtils.cp(temp.path, auth_file)
    end
    true
  end

  def clear
    open(auth_file, 'w') { |file| file.puts '# Managed by gitlab-shell' }
    true
  end
end
