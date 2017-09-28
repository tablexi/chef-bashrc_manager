if defined?(ChefSpec)
  def add_bashrc(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:bashrc, :add, resource_name)
  end

  def remove_bashrc(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:bashrc, :remove, resource_name)
  end
end
