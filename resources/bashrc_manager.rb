resource_name :bashrc_manager

property :filename, String, name_property: true
property :user, String, required: true
property :content, String, default: ''

default_action :add

action_class do
  require 'etc'

  def bashrc
    ::File.join(::Dir.home(new_resource.user), '.bashrc')
  end

  def bashrc_d
    ::File.join(::Dir.home(new_resource.user), '.bashrc.d')
  end

  def bashrc_init
    ::File.join(bashrc_d, 'init')
  end

  def duplicate_content?(filename)
    return ::IO.read(filename).downcase.include?(new_resource.content) if ::File.exist? filename
  end

  def group_gid
    Etc.getpwnam(new_resource.user).gid
  end

  def initial_config?
    ::File.directory?(bashrc_d)
  end
end

action :add do # rubocop:disable Metrics/BlockLength
  directory bashrc_d do
    owner new_resource.user
    group group_gid
    mode 0o755
  end

  file bashrc_init do
    if ::File.exist?(bashrc)
      content ::IO.read(bashrc)
    else
      action :touch
    end
    mode 0o444
    not_if { ::File.exist?(bashrc_init) }
  end

  cookbook_file bashrc do
    cookbook 'bashrc_manager'
    source 'bashrc'
    owner new_resource.user
    group group_gid
    mode 0o644
  end

  file ::File.join(bashrc_d, new_resource.filename) do
    content <<-TXT
# Managed by Chef.  Local changes will be overwritten.
#{new_resource.content}
    TXT
    owner new_resource.user
    group group_gid
    mode 0o644
  end

  log "bashrc_manager_#{new_resource.filename}" do
    level :warn
    message "bashrc_manager: #{new_resource.filename} adds duplicate content."
    only_if { duplicate_content?(bashrc) || duplicate_content?(bashrc_init) }
  end
end

action :remove do
  file ::File.join(bashrc_d, new_resource.filename) do
    action :delete
  end
end
